class AircraftsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_aircraft, only: [:show, :edit, :update, :destroy]
  before_action :ensure_pilot, only: [:new, :create, :edit, :update, :destroy]
  before_action :ensure_owner, only: [:edit, :update, :destroy]

  def index
    @aircrafts = current_user.pilot? ? current_user.aircraft : Aircraft.none
  end

  def show
  end

  def new
    @aircraft = current_user.aircraft.build
  end

  def create
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
    redirect_to aircrafts_path, notice: 'Aircraft was successfully removed.'
  end

  private

  def set_aircraft
    @aircraft = Aircraft.find(params[:id])
  end

  def aircraft_params
    params.require(:aircraft).permit(:registration, :model, :capacity, :manufacture_date, :range_nm)
  end

  def ensure_pilot
    unless current_user.pilot?
      redirect_to root_path, alert: 'Only pilots can manage aircraft.'
    end
  end

  def ensure_owner
    unless @aircraft.owner == current_user
      redirect_to root_path, alert: 'You can only manage your own aircraft.'
    end
  end
end 