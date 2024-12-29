class AircraftController < ApplicationController
  before_action :authenticate_user!
  before_action :set_aircraft, only: [:show, :edit, :update, :destroy]
  before_action :authorize_aircraft!, only: [:edit, :update, :destroy]

  def index
    @aircraft = if current_user.pilot?
      current_user.aircraft
    else
      Aircraft.none
    end
  end

  def show
  end

  def new
    unless current_user.pilot?
      redirect_to root_path, alert: 'Only pilots can register aircraft.'
      return
    end

    @aircraft = current_user.aircraft.build
  end

  def create
    unless current_user.pilot?
      redirect_to root_path, alert: 'Only pilots can register aircraft.'
      return
    end

    @aircraft = current_user.aircraft.build(aircraft_params)

    if @aircraft.save
      redirect_to @aircraft, notice: 'Aircraft was successfully registered.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @aircraft.update(aircraft_params)
      redirect_to @aircraft, notice: 'Aircraft was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @aircraft.destroy
    redirect_to aircraft_index_path, notice: 'Aircraft was successfully removed.'
  end

  private

  def set_aircraft
    @aircraft = Aircraft.find(params[:id])
  end

  def authorize_aircraft!
    unless @aircraft.owner == current_user
      redirect_to aircraft_index_path, alert: 'You are not authorized to modify this aircraft.'
    end
  end

  def aircraft_params
    params.require(:aircraft).permit(:registration, :model, :capacity, :manufacture_date, :range_nm)
  end
end 