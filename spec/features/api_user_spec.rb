require 'rails_helper'
require 'byebug'
require 'spec_helper'
require 'pry'

RSpec.feature 'Api User', type: :feature do

  scenario 'show error message after invalid submission' do
    puts('in here')
    visit '/api_users/new'
    expect(page).to have_content('Create your API key')
  end
end
