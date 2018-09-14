class Authority < ApplicationRecord
  has_many :registers

  scope :authorities, -> { Authority.all }

  scope :collection, ->(id) {
    Authority.find_by(government_organisation_key: id)
  }

  def registers_by_this_authority
    @registers_by_this_authority ||= registers
  end

  def register_count
    @register_count ||= registers.count
  end
end
