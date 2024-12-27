module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin
    
    def index
      @total_users = User.count
      @admin_users = User.where(admin: true).count
      @regular_users = User.where(admin: false).count
    end
    
    private
    
    def authorize_admin
      unless current_user&.admin?
        flash[:alert] = "You are not authorized to access this area."
        redirect_to root_path
      end
    end
  end
end
