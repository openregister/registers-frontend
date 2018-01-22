class AddEntryNumberAndPreviousEntryNumberToEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :entries, :entry_number, :integer
    add_column :entries, :previous_entry_number, :integer
  end
end
