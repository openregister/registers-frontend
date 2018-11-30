class AddTitleToRegister < ActiveRecord::Migration[5.2]
  def change
    add_column :registers, :title, :string

    Register.find_each do |r|
      r.title = Record.where(register_id: r.id, entry_type: 'system', key: 'register-name').pluck(Arel.sql("data -> 'register-name' as register_name")).first || r.name
      r.save
    end
  end
end
