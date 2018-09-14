class ObjectsFactory
  include FactoryBot::Syntax::Methods

  def create_register(name, phase)
    create(:register, name: name, register_phase: phase)
  end
end
