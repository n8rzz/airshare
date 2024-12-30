# This file loads all seed files in order
puts "Loading seeds..."

# Load all seed files in order
Dir[Rails.root.join('db/seeds/*.rb')].sort.each do |file|
  puts "\nLoading #{File.basename(file)}..."
  load file
end

puts "\nSeeding completed!"
