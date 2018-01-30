class Entry < ApplicationRecord
  has_one :record
  belongs_to :register
end
