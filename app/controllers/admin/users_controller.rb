module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin
    before_action :set_user, only: [:show, :edit, :update, :destroy, :toggle_admin]
    
    def index
      @users = User.all
    end
    
    def show
    end
    
    def edit
    end
    
    def update
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
      else
        render :edit
      end
    end
    
    def destroy
      if @user == current_user
        redirect_to admin_users_path, alert: 'You cannot delete yourself.'
      else
        @user.destroy
        redirect_to admin_users_path, notice: 'User was successfully deleted.'
      end
    end
    
    def search
      @users = User.where('email ILIKE ?', "%#{params[:query]}%")
      render :index
    end
    
    def admins
      @users = User.where(admin: true)
      render :index
    end
    
    def regular_users
      @users = User.where(admin: false)
      render :index
    end
    
    def toggle_admin
      if @user == current_user
        redirect_to admin_user_path(@user), alert: 'You cannot modify your own admin status.'
      else
        if @user.admin?
          @user.revoke_admin!
        else
          @user.make_admin!
        end
        redirect_to admin_user_path(@user), notice: "Admin status #{@user.admin? ? 'granted to' : 'revoked from'} #{@user.email}"
      end
    end
    
    private
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:email, :admin)
    end
    
    def authorize_admin
      unless current_user&.admin?
        flash[:alert] = "You are not authorized to access this area."
        redirect_to root_path
      end
    end
  end
end
