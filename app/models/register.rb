class Register < ApplicationRecord
  before_validation :set_slug

  CURRENT_PHASES = %w[Backlog Discovery Alpha Beta].freeze

  ordered_phases = "CASE register_phase #{CURRENT_PHASES.reverse.each_with_index.map { |p, i| "WHEN '#{p}' THEN #{i}" }.join(' ')} END"

  validates_presence_of :name, :register_phase
  validates_uniqueness_of :name
  validates :slug, uniqueness: true

  scope :by_name, -> { order name: :asc }
  scope :by_popularity, -> { order position: :asc }
  scope :sort_by_phase_name_asc, -> { order(ordered_phases) }
  scope :has_records, -> { where(id: Record.select(:register_id)) }
  scope :available, -> { has_records.or(Register.where(register_phase: 'Backlog')) }
  scope :in_beta, -> { where(register_phase: 'Beta') }
  scope :search_registers, lambda { |search_term|
                             if search_term.present?
                               joins(:register_search_results).merge(RegisterSearchResult.search(search_term))
                             end
                           }
  scope :sort_registers, ->(sort_by) { sort_by == 'name' ? by_name : by_popularity }
  scope :featured, -> { where(featured: true) }
  scope :not_featured, -> { where(featured: false) }
  scope :organisation_count, lambda {
    available
      .in_beta
      .distinct
      .count(:authority_id)
  }
  scope :available_count, -> { available.in_beta.count }

  has_many :entries, dependent: :destroy
  has_many :records, dependent: :destroy
  has_many :register_search_results
  belongs_to :category
  belongs_to :authority

  def register_last_updated
    Record.select('timestamp')
      .where(register_id: id)
      .order(timestamp: :desc)
      .first[:timestamp]
      .to_s
  end

  def register_description
    Record.where(register_id: id, key: "register:#{name.parameterize}")
    .pluck(Arel.sql("data -> 'text' as text"))
    .first
  end

  def register_fields
    ordered_field_keys = fields_array.map { |f| "field:#{f}" }
    Record.where(register_id: id, key: ordered_field_keys)
          .order(Arel.sql("position(key::text in '#{ordered_field_keys.join(',')}')"))
          .map { |entry| entry[:data] }
  end

  def number_of_records
    Record.where(register_id: id, entry_type: 'user').count
  end

  def register_name
    register_phase != 'Backlog' &&
      Record.where(register_id: id, entry_type: 'system', key: 'register-name')
            .pluck(Arel.sql("data -> 'register-name' as register_name")).first || name
  end

  def is_empty?
    records.where(entry_type: 'user').none?
  end

  def show_category_link?
    register_phase == 'Beta' && category.present?
  end

  def reported_phase
    register_phase == 'Beta' ? 'Live' : register_phase
  end

private

  def set_slug
    self.slug = name.try(:parameterize)
    self.slug += "-#{self.class.where(slug: slug).count}" if self.class.where(slug: slug).where.not(id: id).exists?
    slug
  end
end
