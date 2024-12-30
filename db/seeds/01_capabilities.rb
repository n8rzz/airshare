# Create capabilities
Seeds.pilot_capability = Capability.find_or_create_by!(name: 'pilot')
Seeds.passenger_capability = Capability.find_or_create_by!(name: 'passenger')

Seeds.log "\nSeeded Capabilities:"
Seeds.log "==================="
Capability.all.each do |capability|
  Seeds.log "- #{capability.name}"
end 