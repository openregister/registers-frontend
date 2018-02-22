class Record < ApplicationRecord
  belongs_to :register
  scope :current, -> { where("data->> 'end-date' is null") }
end
