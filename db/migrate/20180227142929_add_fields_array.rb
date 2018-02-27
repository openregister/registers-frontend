class AddFieldsArray < ActiveRecord::Migration[5.1]
  def change
    add_column :registers, :fields_array, :text, array: true
  end
end
