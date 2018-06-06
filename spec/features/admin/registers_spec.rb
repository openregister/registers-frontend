require 'rails_helper'

RSpec.feature "Admin registers", type: :feature do
  describe 'listing registers' do
    let!(:user) { FactoryBot.create :user }
    let!(:register) { FactoryBot.create_list :register, 3 }

    before { sign_in(User.first) }

    it 'shows all the registers' do
      visit '/admin/registers'
      expect(page).to have_css '.sortable li', count: 3
    end
  end
end
