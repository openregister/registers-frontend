require 'rails_helper'

RSpec.feature "Admin registers", type: :feature do
  describe 'updating registers' do
    let!(:user) { FactoryBot.create :user }
    let!(:register) { FactoryBot.create_list :register, 3 }

    before do
      sign_in(User.first)
      ObjectsFactory.new.create_authority('Cabinet Office', 'D2')
      ObjectsFactory.new.create_authority('Foreign & Commonwealth Office', 'D13')
    end

    it 'shows all the registers' do
      visit '/admin/registers'
      expect(page).to have_css '.sortable li', count: 3
    end

    it 'Updates a register\'s authority' do
      job = class_double(PopulateRegisterDataInDbJob).
      as_stubbed_const(perform_later: true)
      expect(job).to receive(:perform_later)
      register_id = Register.first.id
      visit "/admin/registers/#{register_id}/edit"
      select 'Foreign & Commonwealth Office', from: 'Authority'
      click_button 'Save'
      expect(Register.find(register_id).authority.name).to eq('Foreign & Commonwealth Office')

      visit "/admin/registers/#{register_id}/edit"
      expect(page).to have_select('Authority', selected: 'Foreign & Commonwealth Office')
    end
  end
end
