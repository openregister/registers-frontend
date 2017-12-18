Spina::User.create(name: 'admin', email: 'registerteam@digital.cabinet-office.gov.uk', password: 'password123', admin: true)
Spina::Account.create(name: 'GOV.UK Registers', theme: 'default')
Spina::NavigationItem.create(navigation_id: Spina::Navigation.first.id, page_id: 2)

Spina::Register.create(
  name: "Country",
  register_phase: "Beta",
  authority: "Foreign and Commonwealth Office",
  custodian: "Tony Worron",
  url: "https://country.beta.openregister.org/",
  history: "",
)
puts "Created Country Register"

Spina::Register.create(
  name: "Territory",
  register_phase: "Beta",
  authority: "Foreign and Commonwealth Office",
  custodian: "Tony Worron",
  url: "https://territory.beta.openregister.org/",
  history: "",
)
puts "Created Territory Register"

Spina::Register.create(
  name: "Local authority eng",
  register_phase: "Beta",
  authority: "Department for Communities and Local Government",
  custodian: "Mark Coram",
  url: "https://local-authority-eng.register.gov.uk/",
  history: "https://registers.cloudapps.digital/registers/local-authority-eng",
)
puts "Created Local authority eng Register"

Spina::Register.create(
  name: "School eng",
  register_phase: "Alpha",
  authority: "Department for Education",
  custodian: "Iain Bradley",
  url: "https://school-eng.alpha.openregister.org/",
  history: "https://registers.cloudapps.digital/registers/school-eng",
)
puts "Created School eng Register"

Spina::Register.create(
  name: "Prison estate",
  register_phase: "Beta",
  authority: "Ministry of Justice",
  custodian: "Richard Carling",
  url: "https://prison-estate.register.gov.uk/",
  history: "https://registers.cloudapps.digital/registers/prison-estate",
)
puts "Created Prison Register"

Spina::Register.create(
  name: "Jobcentre",
  register_phase: "Discovery",
  authority: "Department for Work and Pensions",
  custodian: "",
  url: "http://jobcentre.discovery.openregister.org/",
  history: "",
)
puts "Created Jobcentre Register"

Spina::Register.create(
  name: "Government organisation",
  register_phase: "Beta",
  authority: "Cabinet Office",
  url: "https://government-organisation.register.gov.uk/",
  custodian: "Neil Williams",
  history: "https://registers.cloudapps.digital/registers/government-organisation",
)
puts "Created Government organisation Register"

Spina::Register.create(
  name: "Government domain",
  register_phase: "Beta",
  authority: "Cabinet Office",
  url: "https://government-domain.register.gov.uk/",
  custodian: "Evans Bissessar",
  history: "https://registers.cloudapps.digital/registers/government-domain",
)
puts "Created Government domain Register"

Spina::Register.create(
  name: "Charity",
  register_phase: "Discovery",
  authority: "Cabinet Office",
  url: "https://charity.discovery.register.gov.uk/",
  custodian: "Cabinet Office",
  history: "https://registers.cloudapps.digital/registers/charity",
  )
puts "Created Charity Register"

puts "The CMS is located at http://localhost:3000/admin"
puts "User email is registerteam@digital.cabinet-office.gov.uk"
puts "User password is password123"
