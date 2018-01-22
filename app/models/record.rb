class Record < ApplicationRecord

  belongs_to :spina_register, :class_name => 'Spina::Register'
end
