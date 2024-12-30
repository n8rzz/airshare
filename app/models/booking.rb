class Booking < ApplicationRecord
  belongs_to :flight
  belongs_to :user

  enum status: {
    pending: 0,
    confirmed: 1,
    cancelled: 2,
    checked_in: 3
  }

  validates :status, presence: true
  validate :flight_has_available_capacity
  
  before_validation :set_booking_date, on: :create

  private

  def flight_has_available_capacity
    return unless flight.present?
    
    current_bookings = flight.bookings.where.not(id: id).count
    if current_bookings >= flight.capacity
      errors.add(:base, "Flight is at full capacity")
    end
  end

  def set_booking_date
    self.booking_date ||= Time.current
  end
end
