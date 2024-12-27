require 'rails_helper'

RSpec.describe 'Seeds' do
  it 'creates the correct number of users with proper attributes' do
    # Load seeds
    load Rails.root.join('db/seeds.rb')

    # Check total count
    expect(User.count).to eq(3)

    # Check admin user
    admin = User.find_by(email: 'starship@example.com')
    expect(admin).to be_present
    expect(admin).to be_admin
    expect(admin.valid_password?('skyd!ve')).to be true

    # Check regular users
    expect(User.where(admin: false).count).to eq(2)
    ['user1@example.com', 'user2@example.com'].each do |email|
      user = User.find_by(email: email)
      expect(user).to be_present
      expect(user).not_to be_admin
      expect(user.valid_password?('password123')).to be true
    end
  end
end 