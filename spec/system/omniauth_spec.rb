require 'rails_helper'

RSpec.describe 'OmniAuth Authentication', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  describe 'Google OAuth2', js: true do
    context 'with valid credentials' do
      before do
        mock_google_auth_hash
      end

      it 'signs in user successfully' do
        visit new_user_session_path
        click_button 'Sign in with Google'

        expect(page).to have_content('Successfully authenticated from Google account')
        expect(page).to have_content('test@example.com')
      end

      describe 'form configuration' do
        it_behaves_like 'oauth form validation', 'Google'
      end

      it 'creates a new user if one does not exist' do
        expect {
          visit new_user_session_path
          click_button 'Sign in with Google'
          expect(page).to have_content('Successfully authenticated from Google account')
        }.to change(User, :count).by(1)

        user = User.last
        expect(user.email).to eq('test@example.com')
        expect(user.name).to eq('Test User')
        expect(user.provider).to eq('google_oauth2')
        expect(user.uid).to eq('123456789')
      end

      it 'signs in existing OAuth user' do
        create(:user,
          email: 'test@example.com',
          provider: 'google_oauth2',
          uid: '123456789'
        )

        expect {
          visit new_user_session_path
          click_button 'Sign in with Google'
          expect(page).to have_content('Successfully authenticated from Google account')
        }.not_to change(User, :count)
      end

      it 'handles existing email with different provider' do
        user = create(:user, email: 'test@example.com', password: 'password123')

        visit new_user_session_path
        click_button 'Sign in with Google'
        expect(page).to have_content('Successfully authenticated from Google account')

        user.reload
        expect(user.provider).to eq('google_oauth2')
        expect(user.uid).to eq('123456789')
      end

      it 'preserves admin status when linking accounts' do
        admin_user = create(:user,
          email: 'test@example.com',
          password: 'password123',
          admin: true
        )

        visit new_user_session_path
        click_button 'Sign in with Google'
        expect(page).to have_content('Successfully authenticated from Google account')

        admin_user.reload
        expect(admin_user.admin).to be true
        expect(admin_user.provider).to eq('google_oauth2')
      end
    end

    context 'with invalid credentials' do
      before do
        mock_invalid_google_auth
      end

      it 'shows an error message' do
        visit new_user_session_path
        click_button 'Sign in with Google'

        expect(page).to have_content('Authentication failed, please try again')
      end
    end

    context 'with revoked access' do
      before do
        mock_google_auth_hash_with_revoked_access
      end

      it 'handles authentication failure gracefully' do
        visit new_user_session_path
        click_button 'Sign in with Google'

        expect(page).to have_content('Authentication failed, please try again')
      end
    end

    context 'without email in auth hash' do
      before do
        mock_google_auth_hash_without_email
      end

      it 'handles missing email gracefully' do
        visit new_user_session_path
        click_button 'Sign in with Google'

        expect(page).to have_content('Email address is required')
      end
    end
  end
end 