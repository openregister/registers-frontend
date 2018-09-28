class ObjectsFactory
  include FactoryBot::Syntax::Methods

  def create_register(name, phase)
    create(:register, name: name, register_phase: phase)
  end

  def create_authority(name, government_organisation_key)
    create(:authority, name: name, government_organisation_key: government_organisation_key)
  end
end
