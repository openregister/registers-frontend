Spina::Register.destroy_all
Spina::Navigation.destroy_all
Spina::Navigation.create(name: "header", label: "Header", auto_add_pages: true)

steps = [
  { title: "1. Request a register", phase: "Backlog", content: "", completed: false },
  { title: "2. Register is accepted", phase: "Backlog", content: "", completed: false },
  { title: "3. Agree a custodian", phase: "Backlog", content: "", completed: false },
  { title: "4. Agree dataset", phase: "Discovery", content: "", completed: false },
  { title: "5. Review how feedback is collected", phase: "Discovery", content: "", completed: false },
  { title: "6. Review how register is updated", phase: "Discovery", content: "", completed: false },
  { title: "7. Meet operational standards", phase: "Alpha", content: "", completed: false },
  { title: "8. Meet technical standards", phase: "Alpha", content: "", completed: false },
  { title: "9. Find duplicate lists", phase: "Alpha", content: "", completed: false },
  { title: "10. Review feedback from alpha", phase: "Beta", content: "", completed: false },
  { title: "11. Remove duplicate lists", phase: "Beta", content: "", completed: false }
]

Spina::Register.create(
  name: "Country",
  phase: "Beta",
  owner: "Foreign & Commonwealth Office",
  custodian: "Tony Worron",
  url: "https://country.beta.openregister.org/",
  history: "",
  steps_attributes: steps
)
puts "Created Country Register"

Spina::Register.create(
  name: "Local authority eng",
  phase: "Beta",
  owner: "Dept. for Communities & Local Government",
  custodian: "Stephen McAllister",
  url: "https://local-authority-eng.beta.openregister.org/",
  history: "",
  steps_attributes: steps
)
puts "Created Local authority eng Register"

Spina::Register.create(
  name: "Territory",
  phase: "Beta",
  owner: "Foreign & Commonwealth Office",
  custodian: "Tony Worron",
  url: "https://territory.beta.openregister.org/",
  history: "",
  steps_attributes: steps
)
puts "Created Territory Register"

Spina::Register.create(
  name: "Academy school",
  phase: "Alpha",
  owner: "Dept. for Education",
  custodian: "",
  url: "https://academy-school-eng.alpha.openregister.org/",
  history: "",
  steps_attributes: steps
)
puts "Created Academy school Register"

Spina::Register.create(
  name: "Religious character",
  phase: "Alpha",
  owner: "Dept. for Education",
  custodian: "",
  url: "https://religious-character.alpha.openregister.org/",
  history: "",
  steps_attributes: steps
)
puts "Created Religious character Register"

Spina::Register.create(
  name: "School trust",
  phase: "Alpha",
  owner: "Dept. for Education",
  custodian: "",
  url: "https://school-trust.alpha.openregister.org/",
  history: "",
  steps_attributes: steps
)
puts "Created School trust Register"

Spina::Register.create(
  name: "Diocese",
  phase: "Alpha",
  owner: "Dept. for Education",
  custodian: "",
  url: "https://diocese.alpha.openregister.org/",
  history: "",
  steps_attributes: steps
)
puts "Created Diocese Register"

Spina::Register.create(
  name: "Local authority eng",
  phase: "Alpha",
  owner: "Dept. for Communities & Local Government",
  custodian: "",
  url: "https://local-authority-eng.alpha.openregister.org/",
  history: "",
  steps_attributes: steps
)
puts "Created Local authority eng Register"

Spina::Register.create(
  name: "Prison",
  phase: "Discovery",
  owner: "Ministry of Justice",
  custodian: "",
  url: "http://prison.discovery.openregister.org/",
  history: "",
  steps_attributes: steps
)
puts "Created Prison Register"

Spina::Register.create(
  name: "Jobcentre",
  phase: "Discovery",
  owner: "Dept. for Work & Pensions",
  custodian: "",
  url: "http://jobcentre.discovery.openregister.org/",
  history: "",
  steps_attributes: steps
)
puts "Created Jobcentre Register"

Spina::Register.create(
  name: "Gov. organisation",
  phase: "Discovery",
  owner: "Cabinet Office",
  url: "",
  custodian: "",
  history: "",
  steps_attributes: steps
)
puts "Created Gov. organisation Register"

Spina::Register.create(
  name: "Gov. domain",
  phase: "Discovery",
  owner: "Cabinet Office",
  url: "https://government-domain.discovery.openregister.org/",
  custodian: "",
  history: "",
  steps_attributes: steps
)
puts "Created Gov. domain Register"

Spina::Register.create(
  name: "Local Authority (Wales)",
  phase: "Discovery",
  owner: "Welsh government",
  url: "https://local-authority-wls.discovery.openregister.org/",
  custodian: "",
  history: "",
  steps_attributes: steps
)
puts "Created Local Authority (Wales) Register"
