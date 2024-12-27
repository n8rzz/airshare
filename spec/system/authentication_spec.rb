require 'rails_helper'

RSpec.describe 'Authentication', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'Sign up' do
    it 'allows users to sign up with valid credentials' do
      visit new_user_registration_path
      
      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password', with: 'password123'
      fill_in 'Confirm password', with: 'password123'
      
      expect { click_button 'Sign up' }.to change(User, :count).by(1)
      
      expect(page).to have_text('Welcome! You have signed up successfully.')
      expect(User.last.email).to eq('test@example.com')
    end

    it 'shows validation errors with invalid credentials' do
      visit new_user_registration_path
      
      fill_in 'Email', with: 'invalid-email'
      fill_in 'Password', with: '123'
      fill_in 'Confirm password', with: '456'
      
      click_button 'Sign up'
      
      expect(page).to have_text('Email is invalid')
      expect(page).to have_text("Password confirmation doesn't match Password")
      expect(User.count).to eq(0)
    end

    it 'prevents duplicate email registration' do
      existing_user = create(:user, email: 'taken@example.com')
      
      visit new_user_registration_path
      fill_in 'Email', with: 'taken@example.com'
      fill_in 'Password', with: 'password123'
      fill_in 'Confirm password', with: 'password123'
      
      click_button 'Sign up'
      
      expect(page).to have_text('Email has already been taken')
      expect(User.count).to eq(1)
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
  end

  describe 'Password Reset' do
    let!(:user) { create(:user) }

    it 'allows users to request password reset' do
      visit new_user_password_path
      
      fill_in 'Email', with: user.email
      
      expect { click_button 'Send reset instructions' }.to change { ActionMailer::Base.deliveries.count }.by(1)
      
      expect(page).to have_text('You will receive an email with instructions')
      
      # Verify email content
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to include(user.email)
      expect(email.subject).to include('Reset password instructions')
    end

    it 'shows error message for non-existent email' do
      visit new_user_password_path
      
      fill_in 'Email', with: 'nonexistent@example.com'
      click_button 'Send reset instructions'
      
      expect(page).to have_text('Email not found')
    end

    it 'is case-insensitive with email addresses' do
      visit new_user_password_path
      
      fill_in 'Email', with: user.email.upcase
      
      expect { click_button 'Send reset instructions' }.to change { ActionMailer::Base.deliveries.count }.by(1)
      
      expect(page).to have_text('You will receive an email with instructions')
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