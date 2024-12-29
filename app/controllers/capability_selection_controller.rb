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
      current_user.update_capabilities(
        pilot: params[:pilot] == "1",
        passenger: params[:passenger] == "1"
      )
    end

    redirect_to root_path, notice: 'Capabilities updated successfully.'
  end
end 