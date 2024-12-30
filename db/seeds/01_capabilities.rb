# Create capabilities
Seeds.pilot_capability = Capability.find_or_create_by!(name: 'pilot')
Seeds.passenger_capability = Capability.find_or_create_by!(name: 'passenger')

puts "\nSeeded Capabilities:"
puts "==================="
Capability.all.each do |capability|
  puts "- #{capability.name}"
end 