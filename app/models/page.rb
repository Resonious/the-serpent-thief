require 'cgi'

class Page < ActiveRecord::Base
  belongs_to :story, inverse_of: :pages
  has_one :blog_post
  has_and_belongs_to_many :tags

  validates_presence_of :content
  validates_presence_of :number, if: :story_id
  validates_uniqueness_of :number, scope: :story_id, if: :number

  before_validation :assure_page_number
  before_validation :assure_blog_post, on: :create

  # default_scope -> { order 'pages.number ASC' }

  def self.published
    where(published: true)
  end

  def self.tagged(tag)
    if tag.is_a?(Tag)
      joins(:tags).where(tags: { id: tag.id })
    else
      joins(:tags).where(tags: { value: tag })
    end
  end

  def self.tag?(tag)
    tagged(tag).exists?
  end

  # NOTE This kind of assumes that it is being called scoped
  # to story already. i.e. @story.pages.tagged_number('tag', 1)
  def self.tagged_number(tag, tagged_number, scope = true)
    tagged_number = tagged_number.to_i
    return nil if tagged_number <= 0

    with_tag = tagged(tag)
    return nil if tagged_number > with_tag.size

    with_tag[tagged_number - 1]
      .tap { |p| p.scope_number_to_tag!(tag, tagged_number) if scope && p }
  end

  def tags=(tag_list)
    new_tags      = tag_list.downcase.split(',')
    existing_tags = tags.map(&:value)

    # If thing out the new tag list to only include tags we don't
    # already have. Additionally, remove any existing tags that
    # aren't in the new list.
    existing_tags.each do |existing_tag|
      index = new_tags.index(existing_tag)
      if index
        new_tags.delete_at(index); next
      end
      tags.where(value: existing_tag).destroy_all
    end

    # Now, the remaining new tags should only include we don't
    # already have.
    new_tags.each do |tag_value|
      tags << Tag.find_or_create_by(value: tag_value)
    end
  end

  def tag_values
    tags.map(&:value).join(',')
  end

  def next(published = true)
    if story_id.nil?
      raise "Page must belong to a story in order to have a 'next' page."
    end

    page_relative_to :+, published
  end

  def previous(published = true)
    if story_id.nil?
      raise "Page must belong to a story in order to have a 'previous' page."
    end

    page_relative_to :-, published
  end

  def number(force = false)
    number_scoped_to_tag? && !force ? @augmented_number : self[:number]
  end

  def scope_number_to_tag!(tag, augmented_number = nil)
    raise 'find a way to get augmented number' if augmented_number.nil?
    @current_tag = case tag
                   when Tag then tag.value
                   else tag
                   end
    @augmented_number = augmented_number
  end

  def number_scoped_to_tag?
    !@current_tag.nil?
  end

  def blog_post_ready?
    blog_post &&
    blog_post.content &&
    !blog_post.content.empty?
  end

  def first_5_words
    index = 0
    spaces = 0
    on_space = false
    clean_content = HTML::FullSanitizer.new
      .sanitize(CGI.unescapeHTML(content))
      .gsub(/(\&nbsp;)|(<\/p>)/, ' ')

    clean_content.split(/\s+/).take(5).join(' ')
    # clean_content.each_char do |char|
    #   if /\s/ =~ char
    #     unless on_space
    #       spaces += 1
    #       on_space = true
    #     end
    #   else
    #     on_space = false
    #   end
    #   break if spaces >= 5 && !on_space
    #   index += 1
    # end
    # clean_content.byteslice(0, index).strip
  end

  private

  def page_relative_to(dir, published = true)
    next_number = number.send(dir, 1)

    pages = Page.where(story_id: story_id)
    pages = pages.where(published: true) if published
    if number_scoped_to_tag?
      pages = pages.tagged_number(@current_tag, next_number)
    else
      pages = pages.where(number: next_number)
    end

    page = pages.is_a?(Page) ? pages : pages.try(:first)
    if page && number_scoped_to_tag?
      page.scope_number_to_tag!(@current_tag, next_number)
    end
    page
  end

  def assure_page_number
    if self.number.nil? && !self.story.nil?
      story.pages.map(&:number).compact.max.tap do |max_page|
        if max_page
          self.number = max_page + 1
        else
          self.number = 1
        end
      end
    end
  end

  def assure_blog_post
    self.blog_post = BlogPost.create if self.blog_post.nil?
  end
end
