# Airport data
airports = {
  west_coast: ['KSFO', 'KLAX', 'KSEA'],
  east_coast: ['KJFK', 'KBOS', 'KMIA'],
  central: ['KORD', 'KDEN', 'KDFW']
}

flight_times = {
  west_to_east: 6.hours,
  west_to_central: 4.hours,
  central_to_east: 3.hours,
  short_hop: 2.hours
}

# Get pilots and their aircraft
pilot_aircraft = Aircraft.includes(:owner).all.to_a

# Create 10 flights with different statuses and times
10.times do |i|
  # Rotate through pilots and their aircraft
  aircraft = pilot_aircraft[i % pilot_aircraft.length]
  pilot = aircraft.owner

  # Determine origin and destination
  case i % 3
  when 0
    origin = airports[:west_coast].sample
    destination = airports[:east_coast].sample
    duration = flight_times[:west_to_east]
  when 1
    origin = airports[:central].sample
    destination = airports[:east_coast].sample
    duration = flight_times[:central_to_east]
  else
    origin = airports[:west_coast].sample
    destination = airports[:central].sample
    duration = flight_times[:west_to_central]
  end

  # Set times based on status
  departure_time = case i % 5
    when 0 then 2.days.from_now
    when 1 then 1.hour.from_now
    when 2 then 1.day.from_now
    when 3 then 3.hours.from_now
    else 12.hours.from_now
  end

  status = case i % 5
    when 0 then :scheduled
    when 1 then :in_air
    when 2 then :scheduled
    when 3 then :completed
    else :boarding
  end

  flight = Flight.create!(
    pilot: pilot,
    aircraft: aircraft,
    origin: origin,
    destination: destination,
    departure_time: departure_time,
    estimated_arrival_time: departure_time + duration,
    actual_departure_time: (status == :in_air || status == :completed) ? departure_time - 2.hours : nil,
    actual_arrival_time: status == :completed ? departure_time - 1.hour : nil,
    status: status,
    capacity: [aircraft.capacity - (rand(1..2)), 1].max
  )
end

puts "\nSeeded Flights:"
puts "=============="
Flight.all.each do |flight|
  puts "#{flight.origin} to #{flight.destination} (#{flight.status}, pilot: #{flight.pilot.email})"
  puts "  Departure: #{flight.departure_time}"
  puts "  Bookings: #{flight.bookings.count}/#{flight.capacity}"
end 