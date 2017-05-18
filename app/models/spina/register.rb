module Spina
  class Register < ActiveRecord::Base

    before_validation :set_slug

    CURRENT_PHASES = ['Backlog', 'Discovery', 'Alpha', 'Beta']
    AUTHORITIES = OpenRegister.register('government-organisation', :alpha)
                              ._all_records
                              .reject{ |r| r.end_date.present? }
                              .sort_by(&:name)
                              .map(&:name)

    validates_presence_of :name, :register_phase, :authority
    validates_uniqueness_of :name
    validates :slug, uniqueness: true

    has_many :steps, -> { order('position ASC') }
    accepts_nested_attributes_for :steps, reject_if: :all_blank, allow_destroy: true
    has_many :phases, -> { order('position ASC') }
    accepts_nested_attributes_for :phases, reject_if: :all_blank, allow_destroy: true

    scope :by_phase, -> (phase) { where register_phase: phase }
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
