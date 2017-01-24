module Spina
  class Register < ActiveRecord::Base

    before_validation :set_slug

    PHASES = ['Backlog', 'Discovery', 'Alpha', 'Beta', 'Live']
    OWNERS = ['Companies House', 'Ministry of Justice', 'Department for Education', 'Foreign Commonwealth Office', 'Welsh government',
              'Government Digital Service', 'Dept. for Work & Pensions', 'Home Office', 'Valuation Office Agency', 'Cabinet Office',
              'NHS', 'Government Statistical Service', 'Dept. for Communities & Local Government', 'Dept. for Environment, Food, & Rural Affairs']

    validates_presence_of :name, :url, :phase, :owner
    validates_uniqueness_of :name
    validates :slug, uniqueness: true

    has_many :steps, -> { order('position DESC') }
    accepts_nested_attributes_for :steps, reject_if: :all_blank, allow_destroy: true

    private

    def set_slug
      self.slug = name.try(:parameterize)
      self.slug += "-#{self.class.where(slug: slug).count}" if self.class.where(slug: slug).where.not(id: id).count > 0
      slug
    end
  end
end
