module Admin
  class PasswordResetsController < AdminController
    skip_before_action :authorise_user

    def new; end

    def create
      user = User.find_by(email: params[:email])

      if user.present?
        user.regenerate_password_reset_token
        UserMailer.forgot_password(user).deliver_now
        redirect_to admin_login_path, flash: { success: 'Please check your email' }
      else
        flash[:alert] = 'No user found with the provided email address'
        render :new
      end
    end

    def edit
      @user = User.find_by!(password_reset_token: params[:id])
    end

    def update
      @user = User.find_by(password_reset_token: params[:id])

      if @user.update_attributes(user_params)
        redirect_to admin_login_path, flash: { success: 'Successfully updated your password' }
      else
        render :edit
      end
    end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end
end
