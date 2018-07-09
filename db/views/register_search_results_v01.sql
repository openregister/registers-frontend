
SELECT registers.id AS register_id,
       registers.name,
       CAST(register_name_data.data->'register-name' AS varchar) AS register_name,
       CAST(register_description_data.data->'text' AS varchar) AS register_description
FROM registers
LEFT JOIN
  (SELECT register_id,
          DATA
   FROM records
   WHERE KEY = 'register-name' AND ENTRY_TYPE='system' ) AS register_name_data ON register_name_data.register_id = registers.id
LEFT JOIN
  (SELECT KEY,
          DATA
   FROM records) AS register_description_data ON register_description_data.key = 'register:' || registers.slug;