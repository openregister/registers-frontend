module Admin
  class AdminController < ApplicationController
    layout 'admin'

    before_action :authorise_user

  private

    def authorise_admin
      render status: 401 unless current_user.admin?
    end

    def authorise_user
      redirect_to admin_signin_url, flash: { notice: 'Not authorised' } unless current_user
    end
  end
end
