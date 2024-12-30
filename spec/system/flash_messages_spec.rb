require 'rails_helper'

RSpec.describe "Flash Messages", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it "displays flash notice and auto-hides after 5 seconds" do
    # Visit a page that will trigger a flash notice
    visit new_user_session_path
    
    # Fill in invalid credentials to trigger a flash message
    fill_in "Email", with: "nonexistent@example.com"
    fill_in "Password", with: "wrongpassword"
    click_button "Sign in"

    # Verify flash message is visible
    expect(page).to have_css(".bg-red-50", text: "Invalid Email or password")
    
    # Wait 4 seconds and verify message is still visible
    sleep 4
    expect(page).to have_css(".bg-red-50", text: "Invalid Email or password")
    
    # Wait 2 more seconds (total 6 seconds) and verify message is gone
    sleep 2
    expect(page).not_to have_css(".bg-red-50", text: "Invalid Email or password")
  end

  it "displays different styles for notice and alert messages" do
    # Test notice (success) message
    user = create(:user)
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
    
    expect(page).to have_css(".bg-green-50") # Success message style
    
    # Test alert (error) message - using a new session
    using_session(:other_session) do
      visit new_user_session_path
      fill_in "Email", with: "wrong@example.com"
      fill_in "Password", with: "wrongpass"
      click_button "Sign in"
      
      expect(page).to have_css(".bg-red-50") # Error message style
    end
  end
end 