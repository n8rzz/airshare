class CapabilitySelectionController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def new
  end

  def create
    success = if params[:guest]
      @user.make_guest!
      true
    else
      @user.update_capabilities(
        pilot: params[:pilot] == "1",
        passenger: params[:passenger] == "1"
      )
    end

    if success
      if params[:pilot] == "1" && @user.pilot? && @user.aircraft.none?
        redirect_to new_aircraft_path, notice: 'Welcome, pilot! Would you like to register your first aircraft? You can always add or modify your aircraft later.'
      else
        redirect_to root_path, notice: 'Capabilities updated successfully.'
      end
    else
      redirect_to new_capability_selection_path, alert: @user.errors.full_messages.to_sentence
    end
  end

  private

  def set_user
    @user = current_user
  end
end 