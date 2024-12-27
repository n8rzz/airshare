# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create admin user
admin = User.create!(
  email: 'starship@example.com',
  password: 'skyd!ve',
  admin: true
)

puts "Created admin user: #{admin.email}"

# Create regular users
regular_users = [
  { email: 'user1@example.com', password: 'password123' },
  { email: 'user2@example.com', password: 'password123' }
].map do |user_attrs|
  user = User.create!(
    email: user_attrs[:email],
    password: user_attrs[:password],
    admin: false
  )
  puts "Created regular user: #{user.email}"
  user
end

puts "\nSeeding completed!"
puts "Total users created: #{User.count}"
puts "Admin users: #{User.where(admin: true).count}"
puts "Regular users: #{User.where(admin: false).count}"
