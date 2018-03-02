class Entry < ApplicationRecord
  include SearchScope
  has_one :record
  belongs_to :register
end
