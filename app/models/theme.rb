class Theme < ApplicationRecord
  has_many :registers

  scope :themes, -> { Theme.all }

  # def registers_in_a_theme theme_id
  #   Register.where(theme_id: theme_id)
  # end

  scope :collection, ->(slug) {
    Theme.find_by(slug: slug)
  }

  def registers_in_this_theme
    @registers ||= registers
  end

  def register_description
    Record.where(register_id: id, key: "register:#{name.parameterize}")
      .pluck(Arel.sql("data -> 'text' as text"))
      .first
  end

  def register_count
    @register_count ||= registers.count
  end

  def register_authority authority
    @authority ||= registers.find_by(slug: 'government-organisation')&.records&.find_by(key: authority)
  end
end
