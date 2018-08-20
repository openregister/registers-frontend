class HelpUsImproveUser
  include ActiveModel::Model
  include ActiveModel::Translation
  attr_accessor :is_government, :gov_what_part_of_government, :gov_what_are_you_using_registers_for, :what_are_you_using_registers_for
end
