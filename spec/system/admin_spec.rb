require 'rails_helper'

RSpec.describe "Admin", type: :system do
  let!(:admin) { User.create!(email: 'admin@example.com', password: 'password123', admin: true) }
  let!(:user) { User.create!(email: 'user@example.com', password: 'password123', admin: false) }

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

    it 'allows deleting users', js: true do
      page.accept_confirm do
        within("tr", text: user.email) do
          click_button 'Delete'
        end
      end

      expect(page).to have_content('User was successfully deleted')
      expect(page).not_to have_content(user.email)
    end

    it 'prevents self-deletion' do
      within("tr", text: admin.email) do
        expect(page).not_to have_button('Delete')
      end
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