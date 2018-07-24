class Record < ApplicationRecord
  include SearchScope
  belongs_to :register
  scope :current, -> { where("end_date is null or end_date > now() at time zone 'utc'") }
  scope :archived, -> { where("end_date <= now() at time zone 'utc'") }
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
    find_by!(
      key: record,
      entry_type: 'user'
      )
  }
end
