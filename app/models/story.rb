class Story < ActiveRecord::Base
  has_many :pages, dependent: :destroy, inverse_of: :story
  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :link
  validates_uniqueness_of :link

  # Only one story should be active at a time.
  validates_uniqueness_of :active, if: :active

  after_create :create_first_page

  def self.active
    find_by(active: true) or first
  end

  def self.with_pages
    joins(:pages)
      .where(pages: { published: true })
      .uniq
  end

  def first_page
    pages.where(number: 1).first or raise "#{name} has no first page!"
  end

  def published_pages
    pages.where published: true
  end

  def tags(published = false)
    (published ? published_pages : pages).tags
  end

  private

  def create_first_page
    pages.create(number: 1, content: "Welcome to #{name}.")
  end
end
