class AddTitleToRegister < ActiveRecord::Migration[5.2]
  def change
    add_column :registers, :title, :string

    Register.find_each do |r|
      r.title = r.name.humanize.gsub(/-/, ' ')
      r.save
    end
  end
end
