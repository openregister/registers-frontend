module Admin
  class SessionsController < AdminController
    skip_before_action :authorise_user

    def new; end

    def create
      user = User.where(email: params[:email]).first
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to admin_root_url
      else
        flash[:alert] = 'Please check the details provided'
        redirect_to admin_signin_path
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_path
    end
  end
end
