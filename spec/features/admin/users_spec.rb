require 'rails_helper'

RSpec.feature "Admin users", type: :feature do
  describe 'listing users' do
    let!(:users) { FactoryBot.create_list :user, 3 }

    before { sign_in(User.first) }

    it 'shows all the users' do
      visit '/admin/users'
      expect(page).to have_css 'table tbody tr', count: 3
    end
  end
end
