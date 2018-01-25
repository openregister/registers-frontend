class Entry < ApplicationRecord
  has_one :record

  belongs_to :spina_register, class_name: 'Spina::Register'
end
