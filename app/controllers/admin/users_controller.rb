module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin
    before_action :set_user, only: [:show, :edit, :update, :destroy, :toggle_admin]
    
    def index
      @users = User.includes(:capabilities).all
    end
    
    def show
    end
    
    def edit
    end
    
    def update
      result = if guest_update?
        handle_guest_update
      elsif capability_update?
        handle_capability_update
      else
        handle_user_update
      end

      if result
        redirect_to admin_user_path(@user), notice: success_message
      else
        redirect_to admin_user_path(@user), alert: @user.errors.full_messages.to_sentence
      end
    rescue StandardError => e
      redirect_to admin_user_path(@user), alert: e.message
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
      @users = User.includes(:capabilities).where('email ILIKE ?', "%#{params[:query]}%")
      render :index
    end
    
    def admins
      @users = User.includes(:capabilities).where(admin: true)
      render :index
    end
    
    def regular_users
      @users = User.includes(:capabilities).where(admin: false)
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

    def guest_update?
      params[:user][:guest] == "1"
    end

    def capability_update?
      params[:user][:capabilities].present?
    end

    def handle_guest_update
      @user.make_guest!
    end

    def handle_capability_update
      capabilities = params[:user][:capabilities].reject(&:blank?).map { |c| [c, "1"] }.to_h
      @user.update_capabilities(capabilities)
    end

    def handle_user_update
      @user.update(user_params)
    end

    def success_message
      if guest_update?
        'User was successfully updated to guest.'
      elsif capability_update?
        'User capabilities were successfully updated.'
      else
        'User was successfully updated.'
      end
    end
  end
end
