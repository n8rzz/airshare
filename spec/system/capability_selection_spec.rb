require 'rails_helper'

RSpec.describe 'Capability Selection', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    ensure_capabilities_exist
  end

  context 'when user completes registration' do
    it 'redirects to capability selection' do
      visit new_user_registration_path
      
      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password', with: 'password123'
      fill_in 'Confirm password', with: 'password123'
      
      click_button 'Sign up'
      
      expect(page).to have_current_path(new_capability_selection_path)
      expect(page).to have_content('Select your capabilities')
    end
  end

  describe 'capability selection page' do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit new_capability_selection_path
    end

    it 'allows selecting pilot capability' do
      check 'Pilot'
      click_button 'Continue'
      
      expect(user.reload).to be_pilot
      expect(page).to have_current_path(root_path)
    end

    it 'allows selecting passenger capability' do
      check 'Passenger'
      click_button 'Continue'
      
      expect(user.reload).to be_passenger
      expect(page).to have_current_path(root_path)
    end

    it 'allows selecting both pilot and passenger capabilities' do
      check 'Pilot'
      check 'Passenger'
      click_button 'Continue'
      
      expect(user.reload).to be_pilot
      expect(user.reload).to be_passenger
      expect(page).to have_current_path(root_path)
    end

    it 'allows continuing as guest' do
      click_button 'Continue as Guest'
      
      expect(user.reload).to be_guest
      expect(page).to have_current_path(root_path)
    end

    it 'disables pilot and passenger checkboxes when selecting guest' do
      check 'Pilot'
      click_button 'Continue as Guest'
      
      expect(user.reload).to be_guest
      expect(user.reload).not_to be_pilot
    end
  end
end 