require 'rails_helper'

RSpec.describe "Seeds" do
  before do
    load Rails.root.join('db/seeds.rb')
  end

  it "creates the correct number of users with proper attributes" do
    # Total users
    expect(User.count).to eq(6)

    # Admin users
    expect(User.where(admin: true).count).to eq(2)
    expect(User.find_by(email: 'starship@example.com')).to be_admin
    expect(User.find_by(email: 'oauth.admin@example.com')).to be_admin

    # Regular users
    expect(User.where(admin: false).count).to eq(4)
    expect(User.find_by(email: 'user1@example.com')).not_to be_admin
    expect(User.find_by(email: 'user2@example.com')).not_to be_admin
    expect(User.find_by(email: 'oauth.user1@example.com')).not_to be_admin
    expect(User.find_by(email: 'oauth.user2@example.com')).not_to be_admin

    # OAuth users
    oauth_users = User.where.not(provider: nil)
    expect(oauth_users.count).to eq(3)
    expect(oauth_users.pluck(:provider).uniq).to eq(['google_oauth2'])
  end

  it "sets correct capabilities_count for each user" do
    # Admin users should have 2 capabilities each
    expect(User.find_by(email: 'starship@example.com').capabilities_count).to eq(2)
    expect(User.find_by(email: 'oauth.admin@example.com').capabilities_count).to eq(2)

    # Regular users have varying capabilities
    expect(User.find_by(email: 'user1@example.com').capabilities_count).to eq(1) # pilot only
    expect(User.find_by(email: 'user2@example.com').capabilities_count).to eq(1) # passenger only
    expect(User.find_by(email: 'oauth.user1@example.com').capabilities_count).to eq(2) # both
    expect(User.find_by(email: 'oauth.user2@example.com').capabilities_count).to eq(0) # guest
  end

  it "creates the correct number of flights with proper attributes" do
    expect(Flight.count).to eq(10)  # Assuming we'll create 10 flights in seeds

    # Check for different flight statuses
    expect(Flight.scheduled.count).to be >= 3
    expect(Flight.in_air.count).to be >= 1
    expect(Flight.completed.count).to be >= 1

    # Verify flight attributes
    flights = Flight.all
    flights.each do |flight|
      expect(flight.origin).to be_present
      expect(flight.destination).to be_present
      expect(flight.pilot).to be_present
      expect(flight.aircraft).to be_present
      expect(flight.capacity).to be > 0
      expect(flight.capacity).to be <= flight.aircraft.capacity
    end
  end

  it "creates bookings for flights" do
    # At least some flights should have bookings
    flights_with_bookings = Flight.joins(:bookings).distinct
    expect(flights_with_bookings.count).to be >= 3

    # Verify booking attributes
    Booking.all.each do |booking|
      expect(booking.user).to be_present
      expect(booking.flight).to be_present
      expect(booking.flight.passengers).to include(booking.user)
    end

    # No flight should be overbooked
    Flight.all.each do |flight|
      expect(flight.bookings.count).to be <= flight.capacity
    end
  end
end 