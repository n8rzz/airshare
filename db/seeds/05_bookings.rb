puts "\nCreating bookings..."

# Get all scheduled and boarding flights
eligible_flights = Flight.where(status: [:scheduled, :boarding])
puts "Found #{eligible_flights.count} eligible flights"

# Get all users with passenger capability
passenger_capability = Capability.find_by!(name: 'passenger')
passengers = User.joins(:capabilities)
                .where(capabilities: { id: passenger_capability.id })
                .distinct
                .to_a
puts "Found #{passengers.count} eligible passengers"

# Create bookings for each eligible flight
eligible_flights.each do |flight|
  next if passengers.empty?
  
  # Don't book the pilot
  available_passengers = passengers.reject { |p| p.id == flight.pilot_id }
  next if available_passengers.empty?
  
  # Book 30-80% of the capacity
  num_bookings = [(flight.capacity * rand(0.3..0.8)).ceil, 1].max
  num_bookings = [num_bookings, available_passengers.count].min
  
  puts "Creating #{num_bookings} bookings for flight #{flight.id} (#{flight.origin} to #{flight.destination})"
  
  # Create bookings
  available_passengers.shuffle.take(num_bookings).each do |passenger|
    Booking.create!(
      user: passenger,
      flight: flight,
      status: :confirmed
    )
    puts "Created booking for #{passenger.email}"
  end
end

puts "\nFinal Flight Status:"
puts "==================="
Flight.all.each do |flight|
  puts "#{flight.origin} to #{flight.destination} (#{flight.status}, pilot: #{flight.pilot.email})"
  puts "  Departure: #{flight.departure_time}"
  puts "  Bookings: #{flight.bookings.count}/#{flight.capacity}"
  if flight.bookings.any?
    puts "  Passengers: #{flight.passengers.pluck(:email).join(', ')}"
  end
end 