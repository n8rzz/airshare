class CapabilitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_capabilities, only: [:select]

  def select
  end

  def update
    selected_capabilities = []
    selected_capabilities << Capability.pilot if params[:pilot] == "1"
    selected_capabilities << Capability.passenger if params[:passenger] == "1"
    
    current_user.capabilities = selected_capabilities
    redirect_to root_path, notice: 'Your capabilities have been updated.'
  end

  def make_guest
    current_user.make_guest!
    redirect_to root_path, notice: 'You are now set as a guest user.'
  end

  private

  def set_capabilities
    @pilot_capability = Capability.pilot
    @passenger_capability = Capability.passenger
  end
end 