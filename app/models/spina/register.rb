module Spina
  class Register < ActiveRecord::Base

    before_validation :set_slug

    CURRENT_PHASES = ['Backlog', 'Discovery', 'Alpha', 'Beta', 'Live']
    AUTHORITIES = ['Companies House', 'Ministry of Justice', 'Department for Education', 'Foreign and Commonwealth Office', 'Welsh government',
              'Government Digital Service', 'Department for Work and Pensions', 'Home Office', 'Valuation Office Agency', 'Cabinet Office',
              'NHS', 'Government Statistical Service', 'Department for Communities and Local Government', 'Department for Environment, Food and Rural Affairs']

    validates_presence_of :name, :register_phase, :authority
    validates_uniqueness_of :name
    validates :slug, uniqueness: true

    has_many :steps, -> { order('position ASC') }
    accepts_nested_attributes_for :steps, reject_if: :all_blank, allow_destroy: true
    has_many :phases, -> { order('position ASC') }
    accepts_nested_attributes_for :phases, reject_if: :all_blank, allow_destroy: true

    private

    def set_slug
      self.slug = name.try(:parameterize)
      self.slug += "-#{self.class.where(slug: slug).count}" if self.class.where(slug: slug).where.not(id: id).count > 0
      slug
    end
  end
end
