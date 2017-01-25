Spina::Register.destroy_all
Spina::Navigation.destroy_all
Spina::Navigation.create(name: "header", label: "Header", auto_add_pages: true)

steps = [
  { title: "1. Request a register", step_phase: "Backlog", content: "", completed: false },
  { title: "2. Register is accepted", step_phase: "Backlog", content: "", completed: false },
  { title: "3. Agree a custodian", step_phase: "Backlog", content: "", completed: false },
  { title: "4. Agree dataset", step_phase: "Discovery", content: "", completed: false },
  { title: "5. Review how feedback is collected", step_phase: "Discovery", content: "", completed: false },
  { title: "6. Review how register is updated", step_phase: "Discovery", content: "", completed: false },
  { title: "7. Meet operational standards", step_phase: "Alpha", content: "", completed: false },
  { title: "8. Meet technical standards", step_phase: "Alpha", content: "", completed: false },
  { title: "9. Find duplicate lists", step_phase: "Alpha", content: "", completed: false },
  { title: "10. Review feedback from alpha", step_phase: "Beta", content: "", completed: false },
  { title: "11. Remove duplicate lists", step_phase: "Beta", content: "", completed: false }
]

phases = [
  { name: "Backlog", phase_update: "" },
  { name: "Discovery", phase_update: "" },
  { name: "Alpha", phase_update: "" },
  { name: "Beta", phase_update: "" },
  { name: "Live", phase_update: "" }
]

Spina::Register.create(
  name: "Country",
  register_phase: "Beta",
  owner: "Foreign & Commonwealth Office",
  custodian: "Tony Worron",
  url: "https://country.beta.openregister.org/",
  history: "",
  steps_attributes: steps,
  phases_attributes: phases
)
puts "Created Country Register"

Spina::Register.create(
  name: "Local authority eng",
  register_phase: "Beta",
  owner: "Dept. for Communities & Local Government",
  custodian: "Stephen McAllister",
  url: "https://local-authority-eng.beta.openregister.org/",
  history: "",
  steps_attributes: steps,
  phases_attributes: phases
)
puts "Created Local authority eng Register"

Spina::Register.create(
  name: "Territory",
  register_phase: "Beta",
  owner: "Foreign & Commonwealth Office",
  custodian: "Tony Worron",
  url: "https://territory.beta.openregister.org/",
  history: "",
  steps_attributes: steps,
  phases_attributes: phases
)
puts "Created Territory Register"

Spina::Register.create(
  name: "Academy school",
  register_phase: "Alpha",
  owner: "Dept. for Education",
  custodian: "",
  url: "https://academy-school-eng.alpha.openregister.org/",
  history: "",
  steps_attributes: steps,
  phases_attributes: phases
)
puts "Created Academy school Register"

Spina::Register.create(
  name: "Religious character",
  register_phase: "Alpha",
  owner: "Dept. for Education",
  custodian: "",
  url: "https://religious-character.alpha.openregister.org/",
  history: "",
  steps_attributes: steps,
  phases_attributes: phases
)
puts "Created Religious character Register"

Spina::Register.create(
  name: "School trust",
  register_phase: "Alpha",
  owner: "Dept. for Education",
  custodian: "",
  url: "https://school-trust.alpha.openregister.org/",
  history: "",
  steps_attributes: steps,
  phases_attributes: phases
)
puts "Created School trust Register"

Spina::Register.create(
  name: "Diocese",
  register_phase: "Alpha",
  owner: "Dept. for Education",
  custodian: "",
  url: "https://diocese.alpha.openregister.org/",
  history: "",
  steps_attributes: steps,
  phases_attributes: phases
)
puts "Created Diocese Register"

Spina::Register.create(
  name: "Local authority eng",
  register_phase: "Alpha",
  owner: "Dept. for Communities & Local Government",
  custodian: "",
  url: "https://local-authority-eng.alpha.openregister.org/",
  history: "",
  steps_attributes: steps,
  phases_attributes: phases
)
puts "Created Local authority eng Register"

Spina::Register.create(
  name: "Prison",
  register_phase: "Discovery",
  owner: "Ministry of Justice",
  custodian: "",
  url: "http://prison.discovery.openregister.org/",
  history: "",
  steps_attributes: steps,
  phases_attributes: phases
)
puts "Created Prison Register"

Spina::Register.create(
  name: "Jobcentre",
  register_phase: "Discovery",
  owner: "Dept. for Work & Pensions",
  custodian: "",
  url: "http://jobcentre.discovery.openregister.org/",
  history: "",
  steps_attributes: steps,
  phases_attributes: phases
)
puts "Created Jobcentre Register"

Spina::Register.create(
  name: "Gov. organisation",
  register_phase: "Discovery",
  owner: "Cabinet Office",
  url: "",
  custodian: "",
  history: "",
  steps_attributes: steps,
  phases_attributes: phases
)
puts "Created Gov. organisation Register"

Spina::Register.create(
  name: "Gov. domain",
  register_phase: "Discovery",
  owner: "Cabinet Office",
  url: "https://government-domain.discovery.openregister.org/",
  custodian: "",
  history: "",
  steps_attributes: steps,
  phases_attributes: phases
)
puts "Created Gov. domain Register"

Spina::Register.create(
  name: "Local Authority (Wales)",
  register_phase: "Discovery",
  owner: "Welsh government",
  url: "https://local-authority-wls.discovery.openregister.org/",
  custodian: "",
  history: "",
  steps_attributes: steps,
  phases_attributes: phases
)
puts "Created Local Authority (Wales) Register"
