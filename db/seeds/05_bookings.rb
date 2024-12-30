Seeds.log "\nCreating bookings..."

# Get all scheduled and boarding flights
eligible_flights = Flight.where(status: [:scheduled, :boarding])
Seeds.log "Found #{eligible_flights.count} eligible flights"

# Get all users with passenger capability
passenger_capability = Capability.find_by!(name: 'passenger')
passengers = User.joins(:capabilities)
                .where(capabilities: { id: passenger_capability.id })
                .distinct
                .to_a
Seeds.log "Found #{passengers.count} eligible passengers"

eligible_flights.each do |flight|
  next if passengers.empty?
  
  # Don't book the pilot
  available_passengers = passengers.reject { |p| p.id == flight.pilot_id }
  next if available_passengers.empty?
  
  # Book 30-80% of the capacity with different statuses
  num_bookings = [(flight.capacity * rand(0.3..0.8)).ceil, 1].max
  num_bookings = [num_bookings, available_passengers.count].min
  
  Seeds.log "Creating #{num_bookings} bookings for flight #{flight.id} (#{flight.origin} to #{flight.destination})"
  
  # Create bookings with different statuses based on flight time
  available_passengers.shuffle.take(num_bookings).each_with_index do |passenger, index|
    status = if flight.departure_time < Time.current
               [:checked_in, :cancelled].sample
             elsif flight.departure_time < 1.hour.from_now
               [:checked_in, :confirmed].sample
             elsif flight.departure_time < 24.hours.from_now
               [:confirmed, :pending].sample
             else
               :pending
             end

    notes = [
      "Vegetarian meal please",
      "Window seat preferred",
      "Aisle seat preferred",
      "Traveling with laptop",
      "Business meeting",
      "Vacation flight",
      nil
    ].sample

    booking = Booking.create!(
      user: passenger,
      flight: flight,
      status: status,
      notes: notes,
      booking_date: rand(1..30).days.ago # Randomize booking dates
    )
    Seeds.log "Created #{status} booking for #{passenger.email} with #{notes ? 'notes' : 'no notes'}"
  end
end

Seeds.log "\nBooking Statistics:"
Seeds.log "==================="
Seeds.log "Total Bookings: #{Booking.count}"
Seeds.log "By Status:"
Booking.group(:status).count.each do |status, count|
  Seeds.log "  #{status}: #{count}"
end

Seeds.log "\nFlight Capacity Usage:"
Seeds.log "==================="
Flight.all.each do |flight|
  Seeds.log "#{flight.origin} to #{flight.destination} (#{flight.status})"
  Seeds.log "  Departure: #{flight.departure_time}"
  Seeds.log "  Bookings: #{flight.bookings.count}/#{flight.capacity}"
  if flight.bookings.any?
    Seeds.log "  Status Breakdown:"
    flight.bookings.group(:status).count.each do |status, count|
      Seeds.log "    #{status}: #{count}"
    end
  end
end 