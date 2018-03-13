require 'rails_helper'

RSpec.feature 'View support', type: :feature do
  scenario 'correct information shown after invalid submission' do
    visit '/support/problem'
    expect(page).to have_content('Report a problem')
    click_button('Submit')
    expect(page).to have_content('Report a problem')
  end
end
