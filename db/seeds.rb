User.create(name: 'admin', email: 'registerteam@digital.cabinet-office.gov.uk', password: 'password123', admin: true)

d13 = Authority.find_or_create_by!(government_organisation_key: 'D13', name: 'Foreign & Commonwealth Office', registers_description: 'Includes countries and territories')
d4 = Authority.find_or_create_by!(government_organisation_key: 'D4', name: 'Ministry of Housing, Communities and Local Government', registers_description: 'Includes local authorities in Northern Ireland')
d18 = Authority.find_or_create_by!(government_organisation_key: 'D18', name: 'Ministry of Justice', registers_description: 'Includes prison estate')
d10 = Authority.find_or_create_by!(government_organisation_key: 'D10', name: 'Department for Work and Pensions', registers_description: 'Includes jobcentres')
d2 = Authority.find_or_create_by!(government_organisation_key: 'D2', name: 'Cabinet Office', registers_description: 'Includes government organisations and services, gov.uk domain names and a register of all registers')
puts('Created Authorities')

Category.create!([
  { name: 'Crime, justice and law', slug: 'crime-justice-and-law', description: 'Includes prison estate', taxon_content_id: 'ba951b09-5146-43be-87af-44075eac3ae9' },
  { name: 'Digital, Data and Technology Profession Capability Framework', slug: 'digital-data-and-technology-profession-capability-framework' },
  { name: 'Education, training and skills', slug: 'education-training-and-skills', description: 'Includes qualification subject areas and assessment methods', taxon_content_id: 'c58fdadd-7743-46d6-9629-90bb3ccc4ef0' },
  { name: 'Environment', slug: 'environment', description: 'Includes internal drainage boards', taxon_content_id: '3cf97f69-84de-41ae-bc7b-7e2cc238fa58' },
  { name: 'Geography', slug: 'geography', description: 'Includes countries, territories and statistical geography' },
  { name: 'Government', slug: 'government', description: 'Includes organisations, services and gov.uk domain names', taxon_content_id: 'e48ab80a-de80-4e83-bf59-26316856a5f9' },
  { name: 'Health and social care', slug: 'health-and-social-care', description: 'Includes allergens', taxon_content_id: '8124ead8-8ebc-4faf-88ad-dd5cbcc92ba8' },
  { name: 'Life circumstances', slug: 'life-circumstances', description: 'Includes registration districts', taxon_content_id: '20086ead-41fc-49cf-8a62-d4e1126f41fc' },
  { name: 'Regional and local government', slug: 'regional-and-local-government', description: 'Includes local authorities', taxon_content_id: '503c5bc7-809a-47b9-83e2-bd0c212dbabb' },
  { name: 'Registers data', slug: 'registers-data', description: 'Includes a register of all registers, register fields and register datatypes' },
  { name: 'Work', slug: 'work', description: 'Includes jobcentres', taxon_content_id: 'd0f1e5a3-c8f4-4780-8678-994f19104b21' }
])
puts("Created Categories")

Register.create(
  name: "Country",
  register_phase: "Beta",
  authority: d13,
  category: Category.find_by!(slug: 'geography')
)
puts "Created Country Register"

Register.create(
  name: "Territory",
  register_phase: "Beta",
  authority: d13,
  category: Category.find_by!(slug: 'geography')
)
puts "Created Territory Register"

Register.create(
  name: "Local authority eng",
  register_phase: "Beta",
  authority: d4,
  category: Category.find_by!(slug: 'geography')
)
puts "Created Local authority eng Register"

Register.create(
  name: "Prison estate",
  register_phase: "Beta",
  authority: d18,
  category: Category.find_by!(slug: 'crime-justice-and-law')
)
puts "Created Prison Register"

Register.create(
  name: "Jobcentre",
  register_phase: "Beta",
  authority: d10,
  category: Category.find_by!(slug: 'work')
)
puts "Created Jobcentre Register"

Register.create(
  name: "Government organisation",
  register_phase: "Beta",
  authority: d2,
  category: Category.find_by!(slug: 'government')
)
puts "Created Government organisation Register"

Register.create(
  name: "Government domain",
  register_phase: "Beta",
  authority: d2,
  category: Category.find_by!(slug: 'government')
)
puts "Created Government domain Register"



puts "The admin interface is located at http://localhost:3000/admin"
puts "User email is registerteam@digital.cabinet-office.gov.uk"
puts "User password is password123"
