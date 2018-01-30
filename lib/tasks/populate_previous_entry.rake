namespace :registers_frontend do
  desc "populate previous entries"
  task populate_previous_entry: :environment do
    Register.find_each do |register|
      entries_by_key = Entry.where(register_id: register.id).group_by(&:key)
      entries_by_key.each do |key, entries|
        entries.sort_by(&:entry_number).reverse.each_cons(2) do |current, previous|
          puts "register #{register.name} setting key #{key}, entry #{current.entry_number} previous entry to #{previous.entry_number}"
          Entry.update(current.id, previous_entry_number: previous.entry_number)
        end
      end
    end
  end
end
