class ObjectsFactory
  include FactoryBot::Syntax::Methods

  def create_register(name, phase, authority)
    create(:register, name: name, register_phase: phase, authority: authority)
  end
end
