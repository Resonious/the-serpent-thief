class Tag < ActiveRecord::Base
  has_and_belongs_to_many :pages
  validates :value, presence: true
  validate :value_is_not_a_story_link

  before_save :strip_value

  private

  def value_is_not_a_story_link
    if Story.where(link: value).exists?
      errors.add(:value, "cannot be the same as a story link.")
    end
  end

  def strip_value
    self.value = value.strip
  end
end
