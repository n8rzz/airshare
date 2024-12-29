class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :update]

  def show
  end

  def update
    if params[:guest]
      @user.make_guest!
    else
      @user.capabilities.clear

      if params[:pilot] == "1"
        pilot_capability = Capability.find_by(name: 'pilot')
        @user.capabilities << pilot_capability
      end

      if params[:passenger] == "1"
        passenger_capability = Capability.find_by(name: 'passenger')
        @user.capabilities << passenger_capability
      end

      # If no capabilities were selected, make user a guest
      @user.make_guest! if @user.capabilities.none?
    end

    redirect_to "/user", notice: 'Capabilities updated successfully.'
  end

  private

  def set_user
    @user = current_user
  end
end 