class Authority < ApplicationRecord
  has_many :registers

  scope :by_authority_name, -> { order name: :asc }

  scope :with_a_register, -> {
    joins(:registers).merge(Register.in_beta).distinct.by_authority_name
  }

  scope :collection, ->(id) {
    Authority.find_by!(government_organisation_key: id)
  }

  def registers_by_this_collection
    @registers_by_this_collection ||= registers.in_beta.has_records.by_name
  end

  def register_count
    @register_count ||= registers.in_beta.count
  end
end
