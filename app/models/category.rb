class Category < ApplicationRecord
  has_many :registers

  scope :by_name, -> { order name: :asc }

  scope :with_a_register, -> {
    joins(:registers).merge(Register.in_beta).distinct.by_name
  }

  scope :with_a_register__homepage, -> {
    Category.with_a_register.reject { |r|
      r.slug == 'digital-data-and-technology-profession-capability-framework'
    }
  }

  scope :collection, ->(slug) {
    Category.find_by!(slug: slug)
  }

  def registers_by_this_collection
    @registers_by_this_collection ||= registers.in_beta
  end

  def register_count
    @register_count ||= registers.in_beta.count
  end
end
