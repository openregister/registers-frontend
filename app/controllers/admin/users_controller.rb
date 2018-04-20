module Admin
  class UsersController < AdminController
    before_action :authorise_admin, except: [:index]

    def index
      @users = User.all
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_url
      else
        flash[:alert] = "Please check errors"
        render :new
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update_attributes(user_params)
        redirect_to admin_users_url
      else
        flash[:alert] = "Please check errors"
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy unless @user == current_user
      redirect_to admin_users_url
    end

  private

    def user_params
      params.require(:user).permit(:admin, :email, :name, :password_digest, :password, :password_confirmation, :last_logged_in)
    end
  end
end
