class Category < ApplicationRecord
  has_many :registers

  scope :by_name, -> { order 'lower(title) asc' }

  scope :with_a_register, -> {
    joins(:registers).merge(Register.in_beta).distinct.by_name
  }

  scope :with_a_register__shown_on_homepage, -> {
    with_a_register.where.not(slug: 'digital-data-and-technology-profession-capability-framework')
  }

  scope :collection, ->(slug) {
    find_by!(slug: slug)
  }

  def registers_by_this_collection
    @registers_by_this_collection ||= registers.in_beta.by_name
  end

  def register_count
    @register_count ||= registers.in_beta.count
  end
end
