class Page < ActiveRecord::Base
  belongs_to :story
  has_one :blog_post

  validates_presence_of :content
  validates_presence_of :number, if: :story_id
  validates_uniqueness_of :number, scope: :story_id, if: :number

  before_validation :assure_page_number
  before_validation :assure_blog_post, on: :create

  default_scope -> { order 'number ASC' }

  def self.published
    where(published: true)
  end

  def next(published = true)
    if story_id.nil?
      raise "Page must belong to a story in order to have a 'next' page."
    end

    page_relative_to '>', :first, published
  end

  def previous(published = true)
    if story_id.nil?
      raise "Page must belong to a story in order to have a 'previous' page."
    end

    page_relative_to '<', :last, published
  end

  private

  def page_relative_to(direction, relative, published = true)
    relation = Page.where(story_id: story_id)
    relation = relation.where(published: true) if published
    relation = relation.where("number #{direction} ?", number)
    relation.send(relative)
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