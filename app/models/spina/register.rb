module Spina
  class Register < ActiveRecord::Base

    before_validation :set_slug

    CURRENT_PHASES = ['Backlog', 'Discovery', 'Alpha', 'Beta', 'Live']
    AUTHORITIES =
                [
                  'Companies House',
                  'Ministry of Justice',
                  'Department for Education',
                  'Foreign and Commonwealth Office',
                  'Welsh government',
                  'Government Digital Service',
                  'Department for Work and Pensions',
                  'Home Office',
                  'Valuation Office Agency',
                  'Cabinet Office',
                  'NHS',
                  'Government Statistical Service',
                  'Department for Communities and Local Government',
                  'Food Standards Agency',
                  'Department for Environment, Food and Rural Affairs',
                  'General Register Office',
                  'National Offender Management Service',
                  'Animal and Plant Health Agency',
                  'HM Passport Office',
                  'Scottish government',
                  'Driver and Vehicle Licensing Agency',
                  'HM Revenue and Customs',
                  'Homes and Communities Agency',
                  'Charity Commission',
                  'The Pensions Regulator',
                  'Department for Transport',
                  'Ministry of Defence',
                  'Department of Health',
                  'The Planning Inspectorate'
                ]

    validates_presence_of :name, :register_phase, :authority
    validates_uniqueness_of :name
    validates :slug, uniqueness: true

    has_many :steps, -> { order('position ASC') }
    accepts_nested_attributes_for :steps, reject_if: :all_blank, allow_destroy: true
    has_many :phases, -> { order('position ASC') }
    accepts_nested_attributes_for :phases, reject_if: :all_blank, allow_destroy: true

    scope :by_phase, -> (phase) { where register_phase: phase }
    scope :by_name, -> { order name: :asc }
    scope :sort_by_phase_name_asc, -> { order("CASE register_phase WHEN 'Live' THEN 1 WHEN 'Beta' THEN 2 WHEN 'Alpha' THEN 3 WHEN 'Discovery' THEN 4 WHEN 'Backlog' THEN 5 END") }
    scope :sort_by_phase_name_desc, -> { order("CASE register_phase WHEN 'Backlog' THEN 1 WHEN 'Discovery' THEN 2 WHEN 'Alpha' THEN 3 WHEN 'Beta' THEN 4 WHEN 'Live' THEN 5 END") }

    private

    def set_slug
      self.slug = name.try(:parameterize)
      self.slug += "-#{self.class.where(slug: slug).count}" if self.class.where(slug: slug).where.not(id: id).count > 0
      slug
    end
  end
end
