class SignUpController < ApplicationController
  include FormHelpers

  def sign_up_for_updates
    @sign_up_user = SignUpUser.new
  end

  def thank_you_for_signing_up; end
end
