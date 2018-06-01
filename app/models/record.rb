class Record < ApplicationRecord
  include SearchScope
  belongs_to :register
  scope :current, -> { where("data->> 'end-date' is null") }
  scope :archived, -> { where("data->> 'end-date' is not null") }
  scope :status, lambda { |status|
    case status
    when 'archived', 'current'
      send(status)
    when 'all'
      nil
    else
      current
    end
  }

  scope :sort_by_field, lambda { |sort_by, sort_direction|
    order("data->> '#{sort_by}' #{sort_direction.upcase} nulls last")
  }

  scope :record, lambda { |record|
    if record.present?
      where(
        key: record
        )
    end
  }
end
