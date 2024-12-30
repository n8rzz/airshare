class CapabilitySelectionController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def new
  end

  def create
    if params[:guest]
      @user.make_guest!
      redirect_to root_path, notice: 'Capabilities updated successfully.'
      return
    end

    @user.update_capabilities(
      pilot: params[:pilot] == "1",
      passenger: params[:passenger] == "1"
    )

    unless @user.errors.empty?
      redirect_to new_capability_selection_path, alert: @user.errors.full_messages.to_sentence
      return
    end

    if params[:pilot] == "1" && @user.pilot? && @user.aircraft.empty?
      redirect_to new_aircraft_path, 
        notice: 'Welcome, pilot! Would you like to register your first aircraft? You can always add or modify your aircraft later.'
      return
    end

    redirect_to root_path, notice: 'Capabilities updated successfully.'
  end

  private

  def set_user
    @user = current_user
  end
end 