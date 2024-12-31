require 'rails_helper'

RSpec.describe 'Authentication', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'Sign up' do
    context 'with regular registration' do
      it 'allows users to sign up with valid credentials' do
        visit new_user_registration_path
        
        fill_in 'Email address', with: 'test@example.com'
        fill_in 'Password', with: 'password123'
        fill_in 'Confirm password', with: 'password123'
        
        expect { click_button 'Create account' }.to change(User, :count).by(1)
        
        expect(page).to have_text('Welcome! You have signed up successfully.')
        expect(User.last.email).to eq('test@example.com')
      end

      it 'shows validation errors with invalid credentials' do
        visit new_user_registration_path
        
        fill_in 'Email address', with: 'invalid-email'
        fill_in 'Password', with: '123'
        fill_in 'Confirm password', with: '456'
        
        click_button 'Create account'
        
        expect(page).to have_text('Email is invalid')
        expect(page).to have_text("Password confirmation doesn't match Password")
        expect(User.count).to eq(0)
      end

      it 'prevents duplicate email registration' do
        existing_user = create(:user, email: 'taken@example.com')
        
        visit new_user_registration_path
        fill_in 'Email address', with: 'taken@example.com'
        fill_in 'Password', with: 'password123'
        fill_in 'Confirm password', with: 'password123'
        
        click_button 'Create account'
        
        expect(page).to have_text('Email has already been taken')
        expect(User.count).to eq(1)
      end
    end

    context 'with OAuth' do
      let(:auth_hash) do
        OmniAuth::AuthHash.new({
          provider: 'google_oauth2',
          uid: '123456',
          info: {
            email: 'test@example.com',
            name: 'Test User',
            image: 'https://example.com/image.jpg'
          }
        })
      end

      before do
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:google_oauth2] = auth_hash
      end

      after do
        OmniAuth.config.mock_auth[:google_oauth2] = nil
      end

      it 'allows users to sign up with Google' do
        visit new_user_session_path
        expect { click_button 'Sign in with Google' }.to change(User, :count).by(1)
        
        user = User.last
        expect(user.email).to eq('test@example.com')
        expect(user.name).to eq('Test User')
        expect(user.provider).to eq('google_oauth2')
        expect(user.uid).to eq('123456')
        expect(user.avatar_url).to eq('https://example.com/image.jpg')
      end

      it 'links existing account when email matches' do
        existing_user = create(:user, email: 'test@example.com')
        
        visit new_user_session_path
        expect { click_button 'Sign in with Google' }.not_to change(User, :count)
        
        existing_user.reload
        expect(existing_user.provider).to eq('google_oauth2')
        expect(existing_user.uid).to eq('123456')
      end

      it 'shows error when OAuth email is blank' do
        auth_hash.info.email = nil
        
        visit new_user_session_path
        click_button 'Sign in with Google'
        
        expect(page).to have_text('Email address is required')
      end
    end
  end

  describe 'Sign in' do
    let!(:user) { create(:user, email: 'user@example.com', password: 'password123') }

    it 'allows users to sign in with valid credentials' do
      visit new_user_session_path
      
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password123'
      
      click_button 'Sign in'
      
      expect(page).to have_text('Signed in successfully.')
    end

    it 'shows error message with invalid credentials' do
      visit new_user_session_path
      
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'wrong_password'
      
      click_button 'Sign in'
      
      expect(page).to have_text('Invalid Email or password.')
    end

    it 'has no duplicate authentication elements' do
      visit new_user_session_path
      
      expect(page).to have_link('create an account', count: 1)
      expect(page).to have_link('Forgot your password?', count: 1)
      expect(page).to have_selector("input[type='submit'][value='Sign in']", count: 1)
      expect(page).to have_button('Sign in with Google', count: 1)
      expect(page).to have_selector("input[name='authenticity_token']", visible: :hidden)
    end

    it 'remembers user session when remember me is checked' do
      visit new_user_session_path
      
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password123'
      check 'Remember me'
      
      click_button 'Sign in'
      
      expect(page).to have_text('Signed in successfully.')
    end

    it 'is case-insensitive with email addresses' do
      visit new_user_session_path
      
      fill_in 'Email', with: user.email.upcase
      fill_in 'Password', with: 'password123'
      
      click_button 'Sign in'
      
      expect(page).to have_text('Signed in successfully.')
    end

    it 'prevents access to protected pages when not signed in' do
      visit edit_user_registration_path
      
      expect(page).to have_text('You need to sign in or sign up before continuing.')
      expect(page).to have_current_path(new_user_session_path)
    end

    context 'with redirect after login' do
      let!(:flight) { create(:flight, :future) }

      it 'redirects back to the previous page after signing in' do
        # First visit a flight page
        visit flight_path(flight)
        expect(page).to have_current_path(flight_path(flight))

        # Click sign in and complete the sign in process
        click_link 'Sign in', class: 'transform'
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'password123'
        click_button 'Sign in'

        # Should be redirected back to the flight page
        expect(page).to have_current_path(flight_path(flight))
        expect(page).to have_text('Signed in successfully.')
      end

      it 'does not redirect back to sign in page after signing in' do
        # Directly visit sign in page
        visit new_user_session_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'password123'
        click_button 'Sign in'

        # Should not redirect back to sign in page
        expect(page).not_to have_current_path(new_user_session_path)
      end

      it 'does not redirect back to sign up page after signing in' do
        # Visit sign up page first
        visit new_user_registration_path
        # Then go to sign in page and sign in
        click_link 'sign in to your account'
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'password123'
        click_button 'Sign in'

        # Should not redirect back to sign up page
        expect(page).not_to have_current_path(new_user_registration_path)
      end

      it 'maintains redirect after failed login attempt' do
        # First visit a flight page
        visit flight_path(flight)
        click_link 'Sign in', class: 'transform'

        # Attempt login with wrong password
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'wrong_password'
        click_button 'Sign in'

        # Should show error but maintain the redirect
        expect(page).to have_text('Invalid Email or password')

        # Try again with correct password
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'password123'
        click_button 'Sign in'

        # Should redirect to the original flight page
        expect(page).to have_current_path(flight_path(flight))
        expect(page).to have_text('Signed in successfully.')
      end
    end
  end

  describe 'Password Reset' do
    let!(:user) { create(:user) }

    it 'allows users to request password reset' do
      visit new_user_password_path
      
      fill_in 'Email address', with: user.email
      
      expect { click_button 'Reset Password' }.to change { ActionMailer::Base.deliveries.count }.by(1)
      
      expect(page).to have_text('You will receive an email with instructions')
      
      # Verify email content
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to include(user.email)
      expect(email.subject).to include('Reset password instructions')
      
      # Verify email body
      email_body = email.body.to_s
      expect(email_body).to include('Someone has requested a link to change your password')
      expect(email_body).to include('Change my password')
      expect(email_body).to include(edit_user_password_path)
      expect(email_body).to include('If you didn\'t request this')
    end

    it 'rate limits password reset requests' do
      # Send 5 reset password requests in quick succession
      5.times do |i|
        visit new_user_password_path
        fill_in 'Email address', with: user.email
        click_button 'Reset Password'
        if i < 4
          expect(page).to have_text('You will receive an email with instructions')
        end
      end

      # Try one more time - this should be rate limited
      visit new_user_password_path
      fill_in 'Email address', with: user.email
      click_button 'Reset Password'
      
      expect(page).to have_text('Too many password reset attempts')
    end

    context 'when clicking the reset link in email' do
      let(:token) { user.send_reset_password_instructions }
      let(:email) { ActionMailer::Base.deliveries.last }
      let(:reset_link) do
        # Extract reset password link from email body
        email.body.to_s.match(/href="([^"]*)"/).to_a[1]
      end

      before do
        # Clear any existing emails
        ActionMailer::Base.deliveries.clear
        # Send reset instructions to get a fresh token and email
        token
      end

      it 'contains a valid reset password link in the email' do
        expect(reset_link).to be_present
        expect(reset_link).to include('reset_password_token=')
        
        # Visit the reset link from the email
        visit reset_link
        
        expect(page).to have_text('Change your password')
        expect(page).to have_field('New password')
        expect(page).to have_field('Confirm new password')
      end

      it 'invalidates old tokens when requesting a new one' do
        old_token = token
        new_token = user.send_reset_password_instructions
        
        visit edit_user_password_path(reset_password_token: old_token)
        fill_in 'New password', with: 'newpassword123'
        fill_in 'Confirm new password', with: 'newpassword123'
        click_button 'Change my password'
        
        expect(page).to have_text('Reset password token is invalid')
      end

      it 'notifies user when password is changed' do
        visit edit_user_password_path(reset_password_token: token)
        fill_in 'New password', with: 'newpassword123'
        fill_in 'Confirm new password', with: 'newpassword123'
        
        expect { click_button 'Change my password' }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
        
        notification_email = ActionMailer::Base.deliveries.last
        expect(notification_email.subject).to include('Password Changed')
        expect(notification_email.body.to_s).to include('password has been changed')
      end
    end

    it 'shows error message for non-existent email' do
      visit new_user_password_path
      
      fill_in 'Email address', with: 'nonexistent@example.com'
      click_button 'Reset Password'
      
      expect(page).to have_text('Email not found')
    end

    it 'is case-insensitive with email addresses' do
      visit new_user_password_path
      
      fill_in 'Email address', with: user.email.upcase
      
      expect { click_button 'Reset Password' }.to change { ActionMailer::Base.deliveries.count }.by(1)
      
      expect(page).to have_text('You will receive an email with instructions')
    end

    context 'when following the reset password link' do
      let(:token) { user.send_reset_password_instructions }

      it 'allows setting a new password with valid token' do
        visit edit_user_password_path(reset_password_token: token)
        
        fill_in 'New password', with: 'newpassword123'
        fill_in 'Confirm new password', with: 'newpassword123'
        click_button 'Change my password'
        
        expect(page).to have_text('Your password has been changed successfully')
        
        # Sign out first
        click_button 'Sign out'
        
        # Then sign in with the new password
        visit new_user_session_path
        fill_in 'Email address', with: user.email
        fill_in 'Password', with: 'newpassword123'
        click_button 'Sign in'
        expect(page).to have_text('Signed in successfully')
      end

      it 'shows error with password confirmation mismatch' do
        visit edit_user_password_path(reset_password_token: token)
        
        fill_in 'New password', with: 'newpassword123'
        fill_in 'Confirm new password', with: 'differentpassword'
        click_button 'Change my password'
        
        expect(page).to have_text("Password confirmation doesn't match Password")
      end

      it 'shows error with invalid token' do
        visit edit_user_password_path(reset_password_token: 'invalid_token')
        
        fill_in 'New password', with: 'newpassword123'
        fill_in 'Confirm new password', with: 'newpassword123'
        click_button 'Change my password'
        
        expect(page).to have_text('Reset password token is invalid')
      end

      it 'shows error with expired token' do
        # Generate token and travel beyond the expiry window
        token = user.send_reset_password_instructions
        travel 7.hours do
          # Ensure token is expired
          user.update_column(:reset_password_sent_at, 7.hours.ago)
          
          visit edit_user_password_path(reset_password_token: token)
          fill_in 'New password', with: 'newpassword123'
          fill_in 'Confirm new password', with: 'newpassword123'
          click_button 'Change my password'
          
          expect(page).to have_text('Reset password token has expired')
          expect(page).to have_current_path(user_password_path, ignore_query: true)
        end
      end

      it 'enforces minimum password length' do
        visit edit_user_password_path(reset_password_token: token)
        
        fill_in 'New password', with: '123'
        fill_in 'Confirm new password', with: '123'
        click_button 'Change my password'
        
        expect(page).to have_text('Password is too short')
      end
    end
  end

  describe 'Account Settings' do
    let!(:user) { create(:user, password: 'password123') }

    before do
      sign_in_as(user)
      visit edit_user_registration_path
    end

    it 'allows users to update their email with valid password' do
      fill_in 'Email', with: 'newemail@example.com'
      fill_in 'Current password', with: 'password123'
      
      click_button 'Update'
      
      expect(page).to have_text('Your account has been updated successfully.')
      expect(user.reload.email).to eq('newemail@example.com')
    end

    it 'allows users to update their password' do
      fill_in 'New password (leave blank if you don\'t want to change it)', with: 'newpassword123'
      fill_in 'Confirm new password', with: 'newpassword123'
      fill_in 'Current password (we need this to confirm your changes)', with: 'password123'
      
      click_button 'Update'
      
      expect(page).to have_text('Your account has been updated successfully.')
    end

    it 'shows error when current password is incorrect' do
      fill_in 'Email', with: 'newemail@example.com'
      fill_in 'Current password', with: 'wrongpassword'
      
      click_button 'Update'
      
      expect(page).to have_text('Current password is invalid')
    end

    it 'prevents updating to an existing email address' do
      other_user = create(:user, email: 'taken@example.com')
      
      fill_in 'Email', with: 'taken@example.com'
      fill_in 'Current password', with: 'password123'
      
      click_button 'Update'
      
      expect(page).to have_text('Email has already been taken')
    end

    it 'allows update with unchanged email' do
      fill_in 'Email', with: user.email
      fill_in 'Current password', with: 'password123'
      
      click_button 'Update'
      
      expect(page).to have_text('Your account has been updated successfully.')
    end
  end

  describe 'Sign out' do
    let!(:user) { create(:user) }

    it 'allows users to sign out' do
      sign_in_as(user)
      visit root_path
      
      click_button 'Sign out'
      
      expect(page).to have_text('Signed out successfully.')
      expect(page).not_to have_button('Sign out')
      expect(page).to have_link('Sign in')
    end

    it 'redirects to sign in page after signing out' do
      sign_in_as(user)
      visit root_path
      click_button 'Sign out'
      
      visit edit_user_registration_path
      
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_text('You need to sign in or sign up before continuing.')
    end
  end
end 