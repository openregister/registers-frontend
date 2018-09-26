class Category < ApplicationRecord
  has_many :registers

  scope :by_name, -> { order name: :asc }

  scope :with_a_register, -> {
    joins(:registers).merge(Register.in_beta).distinct.by_name
  }

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
