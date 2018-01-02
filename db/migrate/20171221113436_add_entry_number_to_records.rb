class AddEntryNumberToRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :records, :entry_number, :integer
  end
end
