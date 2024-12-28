require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :request do
  describe 'GET /users/auth/google_oauth2/callback' do
    context 'with valid credentials' do
      before do
        mock_google_auth_hash
      end

      it 'creates a new user and redirects to root path' do
        expect {
          get '/users/auth/google_oauth2/callback'
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to include('Successfully authenticated from Google account')
      end

      it 'signs in existing user and redirects to root path' do
        create(:user,
          email: 'test@example.com',
          provider: 'google_oauth2',
          uid: '123456789'
        )

        expect {
          get '/users/auth/google_oauth2/callback'
        }.not_to change(User, :count)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to include('Successfully authenticated from Google account')
      end

      it 'updates user information on login' do
        user = create(:user,
          email: 'test@example.com',
          provider: 'google_oauth2',
          uid: '123456789',
          name: 'Old Name'
        )

        get '/users/auth/google_oauth2/callback'
        user.reload

        expect(user.name).to eq('Test User')
        expect(user.avatar_url).to eq('https://example.com/photo.jpg')
      end

      it 'links OAuth to existing email account' do
        existing_user = create(:user, email: 'test@example.com', password: 'password123')
        
        expect {
          get '/users/auth/google_oauth2/callback'
        }.not_to change(User, :count)

        existing_user.reload
        expect(existing_user.provider).to eq('google_oauth2')
        expect(existing_user.uid).to eq('123456789')
      end

      it 'preserves existing user attributes when linking accounts' do
        existing_user = create(:user,
          email: 'test@example.com',
          password: 'password123',
          admin: true,
          name: 'Custom Name'
        )
        
        get '/users/auth/google_oauth2/callback'
        existing_user.reload

        expect(existing_user.admin).to be true
        expect(existing_user.name).to eq('Test User') # We want to use Google's name
        expect(existing_user.provider).to eq('google_oauth2')
      end
    end

    context 'with invalid credentials' do
      before do
        mock_invalid_google_auth
      end

      it 'redirects to sign in path with error message' do
        get '/users/auth/google_oauth2/callback'

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Authentication failed, please try again.')
      end
    end

    context 'with revoked access' do
      before do
        mock_google_auth_hash_with_revoked_access
      end

      it 'handles revoked access gracefully' do
        get '/users/auth/google_oauth2/callback'

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Authentication failed, please try again.')
      end
    end

    context 'without email in auth hash' do
      before do
        mock_google_auth_hash_without_email
      end

      it 'handles missing email gracefully' do
        get '/users/auth/google_oauth2/callback'

        expect(response).to redirect_to(new_user_registration_url)
        expect(flash[:alert]).to include('Email address is required')
      end
    end
  end
end 