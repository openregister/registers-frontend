class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :registers_available, -> {
    Register.available_count
  }
end
