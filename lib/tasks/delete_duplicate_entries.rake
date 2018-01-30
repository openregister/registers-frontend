namespace :registers_frontend do
  desc "delete duplicate entries"
  task delete_duplicate_entries: :environment do
    sql = "DELETE FROM entries WHERE id IN (SELECT id FROM (SELECT id, ROW_NUMBER() OVER (partition BY register_id, timestamp, entry_type, hash_value, key ORDER BY id DESC) AS rnum FROM entries) t WHERE t.rnum > 1);"
    ActiveRecord::Base.connection.execute(sql)
  end
end
