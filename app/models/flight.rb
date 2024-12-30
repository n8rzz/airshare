class Flight < ApplicationRecord
  belongs_to :pilot, class_name: 'User'
  belongs_to :aircraft
  has_many :bookings, dependent: :destroy
  has_many :passengers, through: :bookings, source: :user

  enum status: {
    scheduled: 0,
    boarding: 1,
    in_air: 2,
    landed: 3,
    completed: 4,
    cancelled: 5,
    delayed: 6,
    diverted: 7
  }

  validates :origin, :destination, :departure_time, :estimated_arrival_time, :capacity, presence: true
  validates :capacity, numericality: { greater_than: 0 }
  validate :departure_time_in_future, :arrival_after_departure
  validate :capacity_within_aircraft_limit

  private

  def departure_time_in_future
    return unless departure_time.present?
    
    if departure_time <= Time.current
      errors.add(:departure_time, "must be in the future")
    end
  end

  def arrival_after_departure
    return unless departure_time.present? && estimated_arrival_time.present?
    
    if estimated_arrival_time <= departure_time
      errors.add(:estimated_arrival_time, "must be after departure time")
    end
  end

  def capacity_within_aircraft_limit
    return unless capacity.present? && aircraft.present?
    
    if capacity > aircraft.capacity
      errors.add(:capacity, "cannot exceed aircraft capacity")
    end
  end
end
