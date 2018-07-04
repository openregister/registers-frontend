class AddRegisterSearchView < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      CREATE VIEW registers_searches AS
      SELECT registers.id AS register_id, registers.name,
      CAST(register_name_data.data->'register-name' AS varchar) AS register_name,
      CAST(register_description_data.data->'text' AS varchar) AS register_description
      FROM registers
      LEFT JOIN (SELECT register_id, data FROM records WHERE key = 'register-name') AS register_name_data
      ON register_name_data.register_id = registers.id
      LEFT JOIN (SELECT key, data from records) AS register_description_data
      ON register_description_data.key = 'register:' || registers.slug;
    SQL
  end

  def down
    execute <<-SQL
    DROP VIEW registers_searches;
    SQL
  end
end
