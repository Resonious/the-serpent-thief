class Story < ActiveRecord::Base
  has_many :pages, dependent: :destroy
  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :link
  validates_uniqueness_of :link

  # Only one story should be active at a time.
  validates_uniqueness_of :active, if: :active

  def self.active
    find_by active: true
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
end