# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create capabilities
pilot_capability = Capability.find_or_create_by!(name: 'pilot')
passenger_capability = Capability.find_or_create_by!(name: 'passenger')

# Create admin user
admin = User.create!(
  email: 'starship@example.com',
  password: 'skyd!ve',
  admin: true
)

# Give admin all capabilities
admin.capabilities = [pilot_capability, passenger_capability]

# Create OAuth admin user
oauth_admin = User.create!(
  email: 'oauth.admin@example.com',
  password: Devise.friendly_token[0, 20],
  admin: true,
  provider: 'google_oauth2',
  uid: '12345',
  name: 'OAuth Admin',
  avatar_url: 'https://example.com/oauth_admin.jpg'
)

# Give OAuth admin all capabilities
oauth_admin.capabilities = [pilot_capability, passenger_capability]

# Create regular users with different auth methods and capabilities
regular_users = [
  # Password-based users
  { 
    email: 'user1@example.com',
    password: 'password123',
    capabilities: [pilot_capability]
  },
  { 
    email: 'user2@example.com',
    password: 'password123',
    capabilities: [passenger_capability]
  },
  
  # OAuth users
  {
    email: 'oauth.user1@example.com',
    password: Devise.friendly_token[0, 20],
    provider: 'google_oauth2',
    uid: '67890',
    name: 'OAuth User 1',
    avatar_url: 'https://example.com/oauth_user1.jpg',
    capabilities: [pilot_capability, passenger_capability]
  },
  {
    email: 'oauth.user2@example.com',
    password: Devise.friendly_token[0, 20],
    provider: 'google_oauth2',
    uid: '11111',
    name: 'OAuth User 2',
    avatar_url: 'https://example.com/oauth_user2.jpg',
    capabilities: []  # Guest user
  }
].map do |user_attrs|
  capabilities = user_attrs.delete(:capabilities)
  user = User.create!(user_attrs.merge(admin: false))
  user.capabilities = capabilities
  user
end

puts "\nSeeded Users:"
puts "============="

User.all.each do |user|
  capabilities = user.capabilities.pluck(:name).join(', ')
  capabilities = 'guest' if capabilities.empty?
  puts "#{user.email} (#{user.admin? ? 'Admin' : 'Regular'}#{user.provider ? ', OAuth' : ''}, #{capabilities})"
end
