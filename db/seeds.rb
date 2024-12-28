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

# Create regular users with different auth methods
regular_users = [
  # Password-based users
  { email: 'user1@example.com', password: 'password123' },
  { email: 'user2@example.com', password: 'password123' },
  
  # OAuth users
  {
    email: 'oauth.user1@example.com',
    password: Devise.friendly_token[0, 20],
    provider: 'google_oauth2',
    uid: '67890',
    name: 'OAuth User 1',
    avatar_url: 'https://example.com/oauth_user1.jpg'
  },
  {
    email: 'oauth.user2@example.com',
    password: Devise.friendly_token[0, 20],
    provider: 'google_oauth2',
    uid: '11111',
    name: 'OAuth User 2',
    avatar_url: 'https://example.com/oauth_user2.jpg'
  }
].map do |user_attrs|
  User.create!(user_attrs.merge(admin: false))
end

puts "\nSeeded Users:"
puts "============="
User.all.each do |user|
  puts "#{user.email} (#{user.admin? ? 'Admin' : 'Regular'}#{user.provider ? ', OAuth' : ''})"
end
