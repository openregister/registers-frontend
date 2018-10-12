class Record < ApplicationRecord
  VALID_FIELD_NAME = /[a-zA-Z\-_\/0-9]+/

  include SearchScope
  belongs_to :register
  scope :current, -> {
    where('end_date is null or end_date > ?', Date.today)
  }

  scope :archived, -> {
    where('end_date <= ?', Date.today)
  }

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
    if sort_by.match?(VALID_FIELD_NAME)
      order(Arel.sql("data->> '#{sort_by}' #{sort_direction.upcase} nulls last"))
    end
  }

  scope :record, lambda { |record|
    find_by!(
      key: record,
      entry_type: 'user'
      )
  }
end
