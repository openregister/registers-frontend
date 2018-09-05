class AddThemeData < ActiveRecord::Migration[5.2]
  def change
    Theme.create!([
      { name: 'Crime, justice and law', slug: 'crime-justice-and-law', description: 'Includes prison estate', taxon_content_id: 'c58fdadd-7743-46d6-9629-90bb3ccc4ef0' },
      { name: 'Digital, Data and Technology Profession Capability Framework', slug: 'digital-data-and-technology-profession-capability-framework' },
      { name: 'Education, training and skills', slug: 'education-training-and-skills', description: 'Includes qualification subject areas and assessment methods', taxon_content_id: 'c58fdadd-7743-46d6-9629-90bb3ccc4ef0' },
      { name: 'Environment', slug: 'environment', description: 'Includes internal drainage boards', taxon_content_id: '3cf97f69-84de-41ae-bc7b-7e2cc238fa58' },
      { name: 'Geography', slug: 'geography', description: 'Includes countries, territories and statistical geography', taxon_content_id: '3cf97f69-84de-41ae-bc7b-7e2cc238fa58' },
      { name: 'Health and social care', slug: 'health-and-social-care', description: 'Includes allergens', taxon_content_id: '8124ead8-8ebc-4faf-88ad-dd5cbcc92ba8' },
      { name: 'Life circumstances', slug: 'life-circumstances', description: 'Includes registration districts', taxon_content_id: '20086ead-41fc-49cf-8a62-d4e1126f41fc' },
      { name: 'Regional and local government', slug: 'regional-and-local-government', description: 'Includes local authorities', taxon_content_id: '503c5bc7-809a-47b9-83e2-bd0c212dbabb' },
      { name: 'Work', slug: 'work', description: 'Includes jobcentres', taxon_content_id: 'd0f1e5a3-c8f4-4780-8678-994f19104b21' }
    ])
  end
end
