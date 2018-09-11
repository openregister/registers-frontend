class Theme < ApplicationRecord
  has_many :registers

  scope :themes, -> { Theme.all }

  scope :registers_in_a_theme, ->(theme_id) {
    Register.where(theme_id: theme_id)
  }
  scope :count_the_registers_in_a_theme, ->(theme_id) {
    registers_in_a_theme(theme_id).count
  }
  scope :count_of_registers_human_readable, ->(theme_id) {
    count = registers_in_a_theme(theme_id).count
    "#{count} #{count == 1 ? 'register' : 'registers'}"
  }

  scope :themes_and_count, -> {
    themes.map { |t|
      {
        name: t.name,
        id: t.id,
        taxon_content_id: t.taxon_content_id,
        description: t.description,
        slug: t.slug,
        count: count_of_registers_human_readable(t.id)
      }
    }
  }
end
