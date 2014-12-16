class Page < ActiveRecord::Base
  belongs_to :story, inverse_of: :pages
  has_one :blog_post

  validates_presence_of :content
  validates_presence_of :number, if: :story_id
  validates_uniqueness_of :number, scope: :story_id, if: :number
  validate :tag_is_not_a_story_link

  before_validation :assure_page_number
  before_validation :assure_blog_post, on: :create

  default_scope -> { order 'number ASC' }

  def self.published
    where(published: true)
  end

  def self.tagged(tag)
    where(tag: tag)
  end

  def self.tag?(tag)
    where(tag: tag).exists?
  end

  def self.tags
    tags = []
    tag  = ''
    until tag.nil?
      tags << tag unless tag.empty?
      tag = where.not(tag: tags).first.try(:tag)
    end
    tags
  end

  # NOTE This kind of assumes that it is being called scoped
  # to story already. i.e. @story.pages.tagged_number('tag', 1)
  def self.tagged_number(tag, number, scope = true)
    return nil unless tag?(tag)
    number = number.to_i
    prior  = offset_to_tag(tag)

    # byebug
    find_by(tag: tag, number: prior + number)
      .tap { |s| s.scope_number_to_tag!(prior) if scope && s }
  end

  def self.offset_to_tag(tag)
    first_page = where(tag: tag).first

    where(story_id: first_page.story_id)
    .where('number < ?', first_page.number)
    .size
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
    num = self[:number]
    return num if force || @tag_number_offset.nil?
    num - @tag_number_offset
  end

  def scope_number_to_tag!(offset = nil)
    @tag_number_offset = offset || Page.offset_to_tag(tag)
  end

  def number_scoped_to_tag?
    !@tag_number_offset.nil?
  end

  private

  def tag_is_not_a_story_link
    if Story.where(link: self.tag).exists?
      errors.add(:tag, %(
        cannot be the same as a story link.
      ))
    end
  end

  def page_relative_to(dir, published = true)
    number = self[:number]
    # TODO You'll have to use where(number > mine).first / where(number < mine).last
    # again in order to account for multiple, discontinuous tags.
    # TODO also remember to make the tag class and join table and to index
    # things :[
    relation = Page.where(story_id: story_id, number: number.send(dir, 1))
    relation = relation.where(published: true) if published
    relation = relation.where(tag: tag)        if number_scoped_to_tag?
    page = relation.first
    if page && number_scoped_to_tag?
      page.scope_number_to_tag!(@tag_number_offset)
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
