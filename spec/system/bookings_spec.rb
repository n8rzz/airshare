require 'rails_helper'

RSpec.describe 'Bookings', type: :system do
  let(:passenger) { create(:user, :passenger) }
  let(:flight) { create(:flight) }

  before do
    driven_by(:rack_test)
    sign_in passenger
  end

  describe 'creating a booking' do
    it 'allows a passenger to book a flight' do
      visit flight_path(flight)
      
      click_on 'Book Flight'
      
      expect(page).to have_content("Book Flight #{flight.origin} to #{flight.destination}")
      expect(page).to have_content("Departure: #{flight.departure_time.strftime('%B %d, %Y at %I:%M %p')}")
      
      fill_in 'Notes', with: 'Vegetarian meal please'
      click_on 'Confirm Booking'
      
      expect(page).to have_content('Booking was successfully created')
      expect(page).to have_content('Status: Pending')
      expect(page).to have_content('Vegetarian meal please')
      
      # Verify booking details
      booking = Booking.last
      expect(booking.user).to eq(passenger)
      expect(booking.flight).to eq(flight)
      expect(booking.status).to eq('pending')
      expect(booking.notes).to eq('Vegetarian meal please')
    end

    it 'shows validation errors' do
      # Create bookings up to capacity
      flight.capacity.times { create(:booking, flight: flight) }
      
      visit new_flight_booking_path(flight)
      
      fill_in 'Notes', with: 'Test booking'
      click_on 'Confirm Booking'
      
      expect(page).to have_content('Flight is at full capacity')
    end
  end
end 