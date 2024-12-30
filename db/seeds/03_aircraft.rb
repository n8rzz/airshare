# Create aircraft for pilots
pilot_users = User.joins(:capabilities).where(capabilities: { name: 'pilot' })
aircraft_data = [
  {
    registration: 'N172SP',
    model: 'Cessna 172S Skyhawk SP',
    capacity: 4,
    manufacture_date: Date.new(2020, 1, 15),
    range_nm: 640
  },
  {
    registration: 'N182RG',
    model: 'Cessna 182 Skylane RG',
    capacity: 4,
    manufacture_date: Date.new(2018, 6, 1),
    range_nm: 915
  },
  {
    registration: 'N28PC',
    model: 'Pilatus PC-12 NG',
    capacity: 9,
    manufacture_date: Date.new(2021, 3, 10),
    range_nm: 1800
  }
]

pilot_users.each_with_index do |pilot, index|
  next unless aircraft_data[index]
  Aircraft.create!(aircraft_data[index].merge(owner: pilot))
end

Seeds.log "\nSeeded Aircraft:"
Seeds.log "==============="
Aircraft.all.each do |aircraft|
  Seeds.log "#{aircraft.registration} (#{aircraft.model}, owned by #{aircraft.owner.email})"
end 