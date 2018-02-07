class Record < ApplicationRecord
  include PgSearch
  belongs_to :register

  pg_search_scope :search_for, against: :data, using: { tsearch: { any_word: true } }
end
