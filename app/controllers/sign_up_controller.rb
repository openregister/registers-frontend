class SignUpController < ApplicationController
  include FormHelpers

  def sign_up_for_updates
    @sign_up_user = SignUpUser.new
    @custom_dimension = params[:from].tr('-', ' ') + ' - ' + params[:method] if params[:from].present? && params[:method].present?
    @params = '/?from=' + params[:from] + '&method=' + params[:method] if params[:from].present? && params[:method].present?;
  end

  def thank_you_for_signing_up;
    @custom_dimension = params[:from].tr('-', ' ') + ' - ' + params[:method] if params[:from].present? && params[:method].present?
  end
end
