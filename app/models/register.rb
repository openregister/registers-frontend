class Register < ApplicationRecord
  before_validation :set_slug

  CURRENT_PHASES = %w[Backlog Discovery Alpha Beta].freeze

  validates_presence_of :name, :register_phase
  validates_uniqueness_of :name
  validates :slug, uniqueness: true

  scope :by_name, -> { order name: :asc }
  scope :sort_by_phase_name_asc, -> { order("CASE register_phase WHEN 'Beta' THEN 2 WHEN 'Alpha' THEN 3 WHEN 'Discovery' THEN 4 WHEN 'Backlog' THEN 5 END") }
  scope :sort_by_phase_name_desc, -> { order("CASE register_phase WHEN 'Backlog' THEN 1 WHEN 'Discovery' THEN 2 WHEN 'Alpha' THEN 3 WHEN 'Beta' THEN 4 END") }
  scope :has_records, -> { where(id: Record.select(:register_id)) }
  scope :available, -> { has_records.or(Register.where(register_phase: 'Backlog')) }

  has_many :entries, dependent: :destroy
  has_many :records, dependent: :destroy

  def last_updated
    Record.select('timestamp')
      .where(register_id: self.id, entry_type: 'user')
      .order(timestamp: :desc)
      .first[:timestamp]
      .to_s
  end

  def register_description
    Record.find_by(register_id: self.id, key: "register:#{self.name.parameterize}").data['text']
  end

  def fields
    ordered_field_keys = Record.find_by(register_id: self.id, key: "register:#{self.name.parameterize}").data['fields'].map { |f| "field:#{f}" }
    Record.where(register_id: self.id, key: ordered_field_keys)
          .order("position(key::text in '#{ordered_field_keys.join(',')}')")
          .map { |entry| entry[:data] }
  end

private

  def set_slug
    self.slug = name.try(:parameterize)
    self.slug += "-#{self.class.where(slug: slug).count}" if self.class.where(slug: slug).where.not(id: id).exists?
    slug
  end
end
