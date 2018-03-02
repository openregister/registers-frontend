class Entry < ApplicationRecord
  include SearchScope
  scope :with_limit, lambda { |page, page_size|
    order(:entry_number)
    .reverse_order
    .limit(page_size)
    .offset(page_size * (page - 1))
  }
  has_one :record
  belongs_to :register
end
