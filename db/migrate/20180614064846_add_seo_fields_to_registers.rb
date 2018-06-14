class AddSeoFieldsToRegisters < ActiveRecord::Migration[5.1]
  def change
    add_column :registers, :seo_title, :string
    add_column :registers, :meta_description, :text
  end
end
