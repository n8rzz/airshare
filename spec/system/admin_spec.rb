require 'rails_helper'

RSpec.describe "Admin", type: :system do
  let!(:admin) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let!(:pilot_capability) { create(:capability, name: 'pilot') }
  let!(:passenger_capability) { create(:capability, name: 'passenger') }

  describe 'admin dashboard' do
    context 'when logged in as admin' do
      before do
        sign_in admin
        visit admin_root_path
      end

      it 'shows admin dashboard' do
        expect(page).to have_content('Admin Dashboard')
        expect(page).to have_content('Total Users')
        expect(page).to have_content('Admin Users')
        expect(page).to have_content('Regular Users')
      end

      it 'displays correct user counts' do
        expect(page).to have_content('Total Users')
        within('[data-test-id="stats-grid"]') do
          expect(page).to have_content('2') # Total users
          expect(page).to have_content('1') # Admin users
          expect(page).to have_content('1') # Regular users
        end
      end
    end

    context 'when logged in as regular user' do
      before do
        sign_in user
        visit admin_root_path
      end

      it 'redirects to root path with alert' do
        expect(current_path).to eq(root_path)
        expect(page).to have_content('You are not authorized to access this area')
      end
    end
  end

  describe 'user management' do
    before do
      sign_in admin
      visit admin_users_path
    end

    it 'lists all users' do
      expect(page).to have_content(admin.email)
      expect(page).to have_content(user.email)
    end

    it 'displays user capabilities' do
      user.capabilities << pilot_capability
      visit admin_users_path
      within("tr", text: user.email) do
        expect(page).to have_content('Pilot')
      end
    end

    it 'allows searching users' do
      fill_in 'query', with: 'admin'
      click_button 'Search'
      expect(page).to have_content(admin.email)
      expect(page).not_to have_content(user.email)
    end

    it 'allows toggling admin status' do
      within("tr", text: user.email) do
        click_button 'Make Admin'
      end

      expect(page).to have_content('Admin status granted to')
      expect(user.reload.admin?).to be true
    end

    it 'prevents toggling own admin status' do
      within("tr", text: admin.email) do
        expect(page).not_to have_button('Revoke Admin')
      end
    end
  end

  describe 'managing user capabilities' do
    let(:user) { create(:user) }

    before do
      sign_in create(:user, :admin)
      visit admin_user_path(user)
    end

    it 'allows adding pilot capability' do
      check 'Pilot'
      click_button 'Update Capabilities'
      
      expect(page).to have_content('User capabilities were successfully updated.')
      expect(user.reload.pilot?).to be true
    end

    it 'allows adding passenger capability' do
      check 'Passenger'
      click_button 'Update Capabilities'
      
      expect(page).to have_content('User capabilities were successfully updated.')
      expect(user.reload.passenger?).to be true
    end

    it 'allows adding both capabilities' do
      check 'Pilot'
      check 'Passenger'
      click_button 'Update Capabilities'
      
      expect(page).to have_content('User capabilities were successfully updated.')
      expect(user.reload.pilot?).to be true
      expect(user.reload.passenger?).to be true
    end

    it 'allows making user a guest' do
      user.capabilities << pilot_capability << passenger_capability
      visit admin_user_path(user)
      
      check 'Guest'
      click_button 'Update Guest Status'
      
      expect(page).to have_content('User was successfully updated to guest.')
      expect(user.reload).to be_guest
    end

    it 'shows validation errors' do
      allow_any_instance_of(User).to receive(:update_capabilities).and_return(false)
      allow_any_instance_of(User).to receive(:errors).and_return(
        double(full_messages: ["Invalid capabilities"], to_sentence: "Invalid capabilities")
      )

      check 'Pilot'
      click_button 'Update Capabilities'
      
      expect(page).to have_content('Invalid capabilities')
    end
  end

  describe 'navigation' do
    context 'when logged in as admin' do
      before do
        sign_in admin
        visit root_path
      end

      it 'shows admin navigation links' do
        expect(page).to have_link('Admin Dashboard')
        expect(page).to have_css('.bg-purple-100', text: 'Admin')
      end
    end

    context 'when logged in as regular user' do
      before do
        sign_in user
        visit root_path
      end

      it 'does not show admin navigation links' do
        expect(page).not_to have_link('Admin Dashboard')
        expect(page).not_to have_css('.bg-purple-100', text: 'Admin')
      end
    end
  end
end 