module FeatureSpecHelpers
  def sign_in(user)
    visit '/admin/signin'
    fill_in :email, with: user.email
    fill_in :password, with: 'password123'
    click_button 'Continue'
  end
end

RSpec.configure do |config|
  config.include FeatureSpecHelpers, type: :feature
end
