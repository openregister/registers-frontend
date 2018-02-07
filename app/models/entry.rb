class Entry < ApplicationRecord
  include PgSearch
  has_one :record
  belongs_to :register

  pg_search_scope :search_for, against: [:key, :data], using: { tsearch: { any_word: true } }
end
