require 'rails_helper'

RSpec.describe 'Flight Creation', type: :system do
  let(:pilot) { create(:user, :pilot) }
  let!(:aircraft) { create(:aircraft, registration: 'N1001', model: 'Cessna 172', capacity: 4, owner: pilot) }
  let(:departure_time) { 1.day.from_now.change(sec: 0) }
  let(:arrival_time) { departure_time + 2.hours }

  before do
    driven_by(:selenium_chrome_headless)
  end

  context 'as a pilot' do
    before do
      login_as(pilot, scope: :user)
      visit new_flight_path
    end

    it 'shows the aircraft capacity when an aircraft is selected' do
      expect(page).to have_content('Select an aircraft to see its capacity')
      
      select "#{aircraft.registration} (#{aircraft.model})", from: 'flight_aircraft_id'
      expect(page).to have_content("Maximum capacity: #{aircraft.capacity} passengers")
    end

    it 'allows creating a new flight with valid data' do
      fill_in 'flight_origin', with: 'KSFO'
      fill_in 'flight_destination', with: 'KLAX'
      
      page.execute_script("document.getElementById('flight_departure_time').value = '#{departure_time.strftime('%Y-%m-%dT%H:%M')}'")
      page.execute_script("document.getElementById('flight_estimated_arrival_time').value = '#{arrival_time.strftime('%Y-%m-%dT%H:%M')}'")
      
      select "#{aircraft.registration} (#{aircraft.model})", from: 'flight_aircraft_id'
      expect(page).to have_content("Maximum capacity: #{aircraft.capacity} passengers")
      
      fill_in 'flight_capacity', with: 3
      
      expect {
        click_button 'Create Flight'
      }.to change(Flight, :count).by(1)

      expect(page).to have_content('Flight was successfully created')
    end

    it 'enforces aircraft capacity limits' do
      select "#{aircraft.registration} (#{aircraft.model})", from: 'flight_aircraft_id'
      expect(page).to have_content("Maximum capacity: #{aircraft.capacity} passengers")
      
      capacity_field = find_field('flight_capacity')
      expect(capacity_field['max']).to eq(aircraft.capacity.to_s)
    end
  end

  context 'as a passenger' do
    let(:passenger) { create(:user) }

    before do
      login_as(passenger, scope: :user)
      visit new_flight_path
    end

    it 'redirects to flights index with an alert' do
      expect(page).to have_current_path(flights_path)
      expect(page).to have_content('Only pilots can manage flights')
    end
  end

  context 'as a visitor' do
    before do
      visit new_flight_path
    end

    it 'redirects to sign in' do
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end 