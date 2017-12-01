class ObjectsFactory
  include FactoryBot::Syntax::Methods

  def create_register(name, phase, authority)
    create(:spina_register, name: name, register_phase: phase, authority: authority)
  end
end