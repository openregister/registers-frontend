class PopulateAuthorityRegisterDescriptions < ActiveRecord::Migration[5.2]
  def change
    Authority.find_by(government_organisation_key: 'D2')&.update(registers_description: 'Includes government organisations and services, gov.uk domain names and a register of all registers')
    Authority.find_by(government_organisation_key: 'OT1173')&.update(registers_description: 'Includes local authorities in Northern Ireland')
    Authority.find_by(government_organisation_key: 'D7')&.update(registers_description: 'Includes internal drainage boards')
    Authority.find_by(government_organisation_key: 'D10')&.update(registers_description: 'Includes jobcentres')
    Authority.find_by(government_organisation_key: 'D102')&.update(registers_description: 'Includes allergens')
    Authority.find_by(government_organisation_key: 'D13')&.update(registers_description: 'Includes countries and territories')
    Authority.find_by(government_organisation_key: 'OT1056')&.update(registers_description: 'Includes approved open standards and Digital, Data and Technology Profession Capability Framework')
    Authority.find_by(government_organisation_key: 'EA66')&.update(registers_description: 'Includes registration districts')
    Authority.find_by(government_organisation_key: 'D4')&.update(registers_description: 'Includes local authorities in England')
    Authority.find_by(government_organisation_key: 'D18')&.update(registers_description: 'Includes prison estate')
    Authority.find_by(government_organisation_key: 'D303')&.update(registers_description: 'Includes statistical geography')
    Authority.find_by(government_organisation_key: 'D109')&.update(registers_description: 'Includes qualification subject areas and assessment methods')
    Authority.find_by(government_organisation_key: 'DA1020')&.update(registers_description: 'Includes local authorities in Scotland')
    Authority.find_by(government_organisation_key: 'DA1019')&.update(registers_description: 'Includes principal local authorities in Wales')
  end
end
