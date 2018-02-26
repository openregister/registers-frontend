Spina::User.create(name: 'admin', email: 'registerteam@digital.cabinet-office.gov.uk', password: 'password123', admin: true)
Spina::Account.create(name: 'GOV.UK Registers', theme: 'default')
Spina::NavigationItem.create(navigation_id: Spina::Navigation.first.id, page_id: 2)

Register.create(
  name: "Country",
  register_phase: "Beta",
  authority: "D13",
)
puts "Created Country Register"

Register.create(
  name: "Territory",
  register_phase: "Beta",
  authority: "D13",
)
puts "Created Territory Register"

Register.create(
  name: "Local authority eng",
  register_phase: "Beta",
  authority: "D4",
)
puts "Created Local authority eng Register"

Register.create(
  name: "School eng",
  register_phase: "Alpha",
  authority: "D6",
)
puts "Created School eng Register"

Register.create(
  name: "Prison estate",
  register_phase: "Beta",
  authority: "D18",
)
puts "Created Prison Register"

Register.create(
  name: "Jobcentre",
  register_phase: "Beta",
  authority: "D10",
)
puts "Created Jobcentre Register"

Register.create(
  name: "Government organisation",
  register_phase: "Beta",
  authority: "D2",
)
puts "Created Government organisation Register"

Register.create(
  name: "Government domain",
  register_phase: "Beta",
  authority: "D2",
)
puts "Created Government domain Register"

Register.create(
  name: "Charity",
  register_phase: "Discovery",
  authority: "D98",
  )
puts "Created Charity Register"

puts "The CMS is located at http://localhost:3000/admin"
puts "User email is registerteam@digital.cabinet-office.gov.uk"
puts "User password is password123"
