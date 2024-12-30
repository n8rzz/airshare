class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_flight, only: [:new, :create]
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :confirm, :check_in, :cancel]
  before_action :ensure_passenger, only: [:new, :create]
  before_action :ensure_owns_booking, only: [:show, :edit, :update, :destroy, :confirm, :check_in, :cancel]

  def index
    @bookings = current_user.bookings
                           .includes(flight: :aircraft)
                           .joins(:flight)
                           .order('flights.departure_time ASC')
  end

  def show
  end

  def new
    @booking = @flight.bookings.build(user: current_user)
  end

  def create
    @booking = @flight.bookings.build(booking_params)
    @booking.user = current_user
    @booking.status = :pending

    if @booking.save
      redirect_to @booking, notice: 'Booking was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      redirect_to @booking, notice: 'Booking was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.destroy
    redirect_to bookings_url, notice: 'Booking was successfully cancelled.'
  end

  def confirm
    if @booking.pending?
      @booking.confirmed!
      redirect_to @booking, notice: 'Booking was successfully confirmed.'
    else
      redirect_to @booking, alert: 'Booking cannot be confirmed.'
    end
  end

  def check_in
    if @booking.confirmed?
      @booking.checked_in!
      redirect_to @booking, notice: 'Successfully checked in.'
    else
      redirect_to @booking, alert: 'Booking cannot be checked in.'
    end
  end

  def cancel
    if @booking.may_cancel?
      @booking.cancelled!
      redirect_to @booking, notice: 'Booking was successfully cancelled.'
    else
      redirect_to @booking, alert: 'Booking cannot be cancelled.'
    end
  end

  private

  def set_flight
    @flight = Flight.find(params[:flight_id])
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:notes)
  end

  def ensure_passenger
    unless current_user.passenger?
      redirect_to flights_path, alert: 'You must be a passenger to book flights.'
    end
  end

  def ensure_owns_booking
    unless @booking.user == current_user
      redirect_to bookings_path, alert: 'You can only manage your own bookings.'
    end
  end
end
