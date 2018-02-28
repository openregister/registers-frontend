class Record < ApplicationRecord
  include SearchScope
  belongs_to :register
  scope :current, -> { where("data->> 'end-date' is null") }
  scope :archived, -> { where("data->> 'end-date' is not null") }
end
