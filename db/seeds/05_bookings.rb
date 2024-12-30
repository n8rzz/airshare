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

# Create bookings for each eligible flight
eligible_flights.each do |flight|
  next if passengers.empty?
  
  # Don't book the pilot
  available_passengers = passengers.reject { |p| p.id == flight.pilot_id }
  next if available_passengers.empty?
  
  # Book 30-80% of the capacity
  num_bookings = [(flight.capacity * rand(0.3..0.8)).ceil, 1].max
  num_bookings = [num_bookings, available_passengers.count].min
  
  Seeds.log "Creating #{num_bookings} bookings for flight #{flight.id} (#{flight.origin} to #{flight.destination})"
  
  # Create bookings
  available_passengers.shuffle.take(num_bookings).each do |passenger|
    Booking.create!(
      user: passenger,
      flight: flight,
      status: :confirmed
    )
    Seeds.log "Created booking for #{passenger.email}"
  end
end

Seeds.log "\nFinal Flight Status:"
Seeds.log "==================="
Flight.all.each do |flight|
  Seeds.log "#{flight.origin} to #{flight.destination} (#{flight.status}, pilot: #{flight.pilot.email})"
  Seeds.log "  Departure: #{flight.departure_time}"
  Seeds.log "  Bookings: #{flight.bookings.count}/#{flight.capacity}"
  if flight.bookings.any?
    Seeds.log "  Passengers: #{flight.passengers.pluck(:email).join(', ')}"
  end
end 