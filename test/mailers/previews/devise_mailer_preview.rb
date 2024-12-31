# Preview Devise emails at http://localhost:3000/rails/mailers/devise_mailer
class DeviseMailerPreview < ActionMailer::Preview
  def reset_password_instructions
    user = User.first || FactoryBot.create(:user)
    Devise::Mailer.reset_password_instructions(user, Devise.friendly_token)
  end

  def confirmation_instructions
    user = User.first || FactoryBot.create(:user)
    Devise::Mailer.confirmation_instructions(user, Devise.friendly_token)
  end

  def unlock_instructions
    user = User.first || FactoryBot.create(:user)
    Devise::Mailer.unlock_instructions(user, Devise.friendly_token)
  end

  def email_changed
    user = User.first || FactoryBot.create(:user)
    Devise::Mailer.email_changed(user)
  end

  def password_change
    user = User.first || FactoryBot.create(:user)
    Devise::Mailer.password_change(user)
  end
end 