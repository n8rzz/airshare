module AuthenticationHelper
  def sign_in_as(user)
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

  def sign_up_as(email:, password:)
    visit new_user_registration_path
    fill_in "Email", with: email
    fill_in "Password", with: password
    fill_in "Confirm password", with: password
    click_button "Sign up"
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :system
end 