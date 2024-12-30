require 'rails_helper'

RSpec.describe 'Flight Access', type: :system do
  let!(:future_flight) { create(:flight, :future) }
  
  describe 'as a visitor' do
    before do
      visit flights_path
    end

    it 'allows viewing the flights index' do
      expect(page).to have_current_path(flights_path)
      expect(page).to have_content('Available Flights')
    end

    it 'shows flight details' do
      expect(page).to have_content(future_flight.origin)
      expect(page).to have_content(future_flight.destination)
    end

    it 'allows viewing individual flight details' do
      click_link "View Details"
      expect(page).to have_current_path(flight_path(future_flight))
      expect(page).to have_content(future_flight.origin)
      expect(page).to have_content(future_flight.destination)
    end

    it 'does not show booking options' do
      expect(page).not_to have_button('Book Flight')
      expect(page).not_to have_link('Book Now')
    end

    it 'does not show flight creation options' do
      expect(page).not_to have_link('New Flight')
      expect(page).not_to have_button('Create Flight')
    end

    it 'shows a sign in prompt when trying to book' do
      click_link "View Details"
      expect(page).to have_content('Sign in to book this flight')
      expect(page).to have_link('Sign in', href: new_user_session_path)
    end
  end

  describe 'header navigation menu' do
    before do
      visit root_path
    end

    it 'shows the flights link to all users' do
      within('nav') do
        expect(page).to have_link('Flights', href: flights_path)
      end
    end

    it 'does not show the bookings link to visitors' do
      within('nav') do
        expect(page).not_to have_link('Bookings')
        expect(page).not_to have_link('My Bookings')
      end
    end

    it 'allows navigation to flights index' do
      within('nav') do
        click_link 'Flights'
      end
      expect(page).to have_current_path(flights_path)
    end
  end
end 