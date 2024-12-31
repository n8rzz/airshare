require 'rails_helper'

RSpec.describe 'User Profile', type: :system do
  let(:user) { create(:user) }
  
  before do
    driven_by(:selenium_chrome_headless)
    ensure_capabilities_exist
    sign_in user
  end

  describe 'viewing profile' do
    before { visit user_path }

    it 'displays user email' do
      expect(page).to have_content(user.email)
    end

    it 'displays user role' do
      expect(page).to have_content('Regular User')
    end

    context 'when user is admin' do
      let(:user) { create(:user, admin: true) }

      it 'displays admin role' do
        expect(page).to have_content('Admin')
      end
    end

    context 'when user is guest' do
      it 'displays guest capability' do
        expect(page).to have_content('Guest')
      end
    end

    context 'when user has capabilities' do
      before do
        user.capabilities << Capability.find_by(name: 'pilot')
        user.capabilities << Capability.find_by(name: 'passenger')
        visit user_path
      end

      it 'displays all user capabilities' do
        expect(page).to have_content('Pilot')
        expect(page).to have_content('Passenger')
      end
    end
  end

  describe 'updating capabilities' do
    before { visit user_path }

    it 'can select pilot capability' do
      check 'Pilot'
      click_button 'Update Capabilities'
      
      expect(page).to have_content('Capabilities updated successfully')
      expect(user.reload).to be_pilot
    end

    it 'can select passenger capability' do
      check 'Passenger'
      click_button 'Update Capabilities'
      
      expect(page).to have_content('Capabilities updated successfully')
      expect(user.reload).to be_passenger
    end

    it 'can select both pilot and passenger capabilities' do
      check 'Pilot'
      check 'Passenger'
      click_button 'Update Capabilities'
      
      expect(page).to have_content('Capabilities updated successfully')
      expect(user.reload).to be_pilot
      expect(user.reload).to be_passenger
    end

    it 'can switch to guest mode' do
      user.capabilities << Capability.find_by(name: 'pilot')
      visit user_path
      
      click_button 'Continue as Guest'
      
      expect(page).to have_content('Capabilities updated successfully')
      expect(user.reload).to be_guest
    end

    it 'becomes guest when no capabilities are selected' do
      user.capabilities << Capability.find_by(name: 'pilot')
      visit user_path
      
      uncheck 'Pilot'
      click_button 'Update Capabilities'
      
      expect(page).to have_content('Capabilities updated successfully')
      expect(user.reload).to be_guest
    end
  end

  describe 'navigation' do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit root_path
    end

    it 'can access profile from navigation dropdown' do
      find('label[for="dropdown-toggle"]').click
      click_link 'Profile'
      expect(page).to have_current_path(user_path)
    end

    it 'can access account settings from navigation dropdown' do
      find('label[for="dropdown-toggle"]').click
      click_link 'Account Settings'
      expect(page).to have_current_path(edit_user_registration_path)
    end
  end
end 