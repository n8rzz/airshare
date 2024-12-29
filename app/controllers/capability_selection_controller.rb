class CapabilitySelectionController < ApplicationController
  before_action :authenticate_user!

  def new
    @pilot_capability = Capability.find_by(name: 'pilot')
    @passenger_capability = Capability.find_by(name: 'passenger')
  end

  def create
    if params[:guest]
      current_user.make_guest!
    else
      # Clear existing capabilities
      current_user.capabilities.clear

      # Add selected capabilities
      if params[:pilot] == "1"
        pilot_capability = Capability.find_by(name: 'pilot')
        current_user.capabilities << pilot_capability
      end

      if params[:passenger] == "1"
        passenger_capability = Capability.find_by(name: 'passenger')
        current_user.capabilities << passenger_capability
      end

      # If no capabilities were selected, make user a guest
      current_user.make_guest! if current_user.capabilities.none?
    end

    redirect_to root_path
  end
end 