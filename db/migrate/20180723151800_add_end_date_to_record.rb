class AddEndDateToRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :records, :end_date, :datetime
  end
end
