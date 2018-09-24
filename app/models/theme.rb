class Theme < ApplicationRecord
  has_many :registers

  scope :themes, -> { Theme.all }

  scope :collection, ->(slug) {
    Theme.find_by(slug: slug)
  }

  def registers_in_this_theme
    @registers_in_this_theme ||= registers.in_beta
  end

  def register_count
    @register_count ||= registers.in_beta.count
  end
end
