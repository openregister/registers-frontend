module Spina
  class Register < ActiveRecord::Base

    before_validation :set_slug

    CURRENT_PHASES = ['Backlog', 'Discovery', 'Alpha', 'Beta']

    validates_presence_of :name, :register_phase
    validates_uniqueness_of :name
    validates :slug, uniqueness: true

    scope :by_name, -> { order name: :asc }
    scope :sort_by_phase_name_asc, -> { order("CASE register_phase WHEN 'Beta' THEN 2 WHEN 'Alpha' THEN 3 WHEN 'Discovery' THEN 4 WHEN 'Backlog' THEN 5 END") }
    scope :sort_by_phase_name_desc, -> { order("CASE register_phase WHEN 'Backlog' THEN 1 WHEN 'Discovery' THEN 2 WHEN 'Alpha' THEN 3 WHEN 'Beta' THEN 4 END") }

    private

    def set_slug
      self.slug = name.try(:parameterize)
      self.slug += "-#{self.class.where(slug: slug).count}" if self.class.where(slug: slug).where.not(id: id).count > 0
      slug
    end
  end
end
