class FlightsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_flight, only: [:show, :edit, :update, :destroy]
  before_action :ensure_pilot, only: [:new, :create, :edit, :update, :destroy]
  before_action :ensure_pilot_owns_flight, only: [:edit, :update, :destroy]

  def index
    @flights = Flight.includes(:pilot, :aircraft)
                    .where('departure_time > ?', Time.current)

    if params[:search].present?
      if params[:search][:query].present?
        query = "%#{params[:search][:query].downcase}%"
        @flights = @flights.where('LOWER(origin) LIKE ? OR LOWER(destination) LIKE ?', 
                                query, query)
      end
      
      if params[:search][:date].present?
        date = Date.parse(params[:search][:date])
        @flights = @flights.where('DATE(departure_time) = ?', date)
      end
    end

    @flights = @flights.order(departure_time: :asc)
  end

  def show
    @booking = @flight.bookings.find_by(user: current_user)
  end

  def new
    @flight = current_user.flights.build
  end

  def create
    Rails.logger.debug "Flight params: #{flight_params.inspect}"
    @flight = current_user.flights.build(flight_params)
    Rails.logger.debug "Flight object: #{@flight.inspect}"
    Rails.logger.debug "Aircraft: #{@flight.aircraft.inspect}" if @flight.aircraft.present?

    if @flight.save
      redirect_to @flight, notice: 'Flight was successfully created.'
    else
      Rails.logger.debug "Flight errors: #{@flight.errors.full_messages}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @flight.update(flight_params)
      redirect_to @flight, notice: 'Flight was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @flight.destroy
    redirect_to flights_url, notice: 'Flight was successfully cancelled.'
  end

  def update_status
    @flight = Flight.find(params[:id])
    
    if ensure_pilot_owns_flight
      if @flight.update(status: params[:status])
        redirect_to @flight, notice: 'Flight status was successfully updated.'
      else
        redirect_to @flight, alert: 'Unable to update flight status.'
      end
    end
  end

  private

  def set_flight
    @flight = Flight.find(params[:id])
  end

  def flight_params
    params.require(:flight).permit(
      :origin, :destination, :departure_time, :estimated_arrival_time,
      :capacity, :aircraft_id, :status
    )
  end

  def ensure_pilot
    unless current_user.pilot?
      redirect_to flights_path, alert: 'Only pilots can manage flights.'
    end
  end

  def ensure_pilot_owns_flight
    unless @flight.pilot == current_user
      redirect_to flights_path, alert: 'You can only manage your own flights.'
      return false
    end
    true
  end
end
