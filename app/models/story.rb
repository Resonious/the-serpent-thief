class Story < ActiveRecord::Base
  has_many :pages, dependent: :destroy, inverse_of: :story
  has_many :tags, -> { uniq }, through: :pages, select: "stories.*, pages.number"
  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :link
  validates_uniqueness_of :link

  # Only one story should be active at a time.
# validates_uniqueness_of :active, if: :active

  before_save :assure_active_unique
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

  private

  def create_first_page
    pages.create(number: 1, content: "Welcome to #{name}.")
  end

  def assure_active_unique
    if active?
      Story.where(active: true).update_all(active: false)
    elsif Story.where(active: true).empty?
      self.active = true
    end
  end
end
