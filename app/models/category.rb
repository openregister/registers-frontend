class Category < ApplicationRecord
  has_many :registers

  scope :themes, -> { Category.all }

  scope :collection, ->(slug) {
    Category.find_by(slug: slug)
  }

  def registers_in_this_theme
    @registers_in_this_theme ||= registers.in_beta
  end

  def register_count
    @register_count ||= registers.in_beta.count
  end
end
