require 'rails_helper'

RSpec.describe 'Bookings', type: :system do
  let(:passenger) { create(:user, :passenger) }
  let(:flight) { create(:flight) }

  before do
    driven_by(:rack_test)
    sign_in passenger
  end

  describe 'viewing bookings' do
    it 'shows all bookings for the current user' do
      my_booking = create(:booking, user: passenger, flight: create(:flight, origin: 'KBOS', destination: 'KLAX'))
      other_booking = create(:booking, flight: create(:flight, origin: 'KSFO', destination: 'KJFK'))
      
      visit bookings_path
      
      expect(page).to have_content('KBOS → KLAX')
      expect(page).not_to have_content('KSFO → KJFK')
    end

    it 'shows appropriate status labels' do
      create(:booking, :pending, user: passenger)
      create(:booking, :confirmed, user: passenger)
      create(:booking, :cancelled, user: passenger)
      create(:booking, :checked_in, user: passenger)
      
      visit bookings_path
      
      expect(page).to have_content('Pending')
      expect(page).to have_content('Confirmed')
      expect(page).to have_content('Cancelled')
      expect(page).to have_content('Checked In')
    end
  end

  describe 'creating a booking' do
    it 'allows a passenger to book a flight' do
      visit flight_path(flight)
      
      click_link 'Book This Flight'
      
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

    it 'shows validation errors when flight is at capacity' do
      flight.capacity.times { create(:booking, flight: flight) }
      
      visit new_flight_booking_path(flight)
      
      fill_in 'Notes', with: 'Test booking'
      click_on 'Confirm Booking'
      
      expect(page).to have_content('Flight is at full capacity')
    end
  end

  describe 'managing a booking' do
    context 'with a pending booking' do
      let!(:booking) { create(:booking, :pending, user: passenger) }

      it 'allows confirming the booking' do
        visit booking_path(booking)
        click_button 'Confirm Booking'
        
        expect(page).to have_content('Booking was successfully confirmed')
        expect(page).to have_content('Status: Confirmed')
      end

      it 'allows cancelling the booking' do
        visit booking_path(booking)
        click_button 'Cancel Booking'
        
        expect(page).to have_content('Booking was successfully cancelled')
        expect(page).to have_content('Status: Cancelled')
      end
    end

    context 'with a confirmed booking' do
      let!(:booking) { create(:booking, :confirmed, user: passenger) }

      it 'allows checking in' do
        visit booking_path(booking)
        click_button 'Check In'
        
        expect(page).to have_content('Successfully checked in')
        expect(page).to have_content('Status: Checked In')
      end
    end

    context 'with a checked-in booking' do
      let!(:booking) { create(:booking, :checked_in, user: passenger) }

      it 'does not show status change buttons' do
        visit booking_path(booking)
        
        expect(page).not_to have_button('Confirm Booking')
        expect(page).not_to have_button('Check In')
        expect(page).not_to have_button('Cancel Booking')
      end
    end
  end

  describe 'accessibility and navigation' do
    let!(:booking) { create(:booking, user: passenger) }

    it 'navigates through the booking workflow' do
      visit bookings_path
      click_link 'View'
      
      expect(page).to have_content('Booking Details')
      expect(page).to have_content(booking.flight.origin)
      expect(page).to have_content(booking.flight.destination)
      
      click_link 'Back to Bookings'
      expect(current_path).to eq(bookings_path)
    end
  end
end 