module OmniauthableUser
  extend ActiveSupport::Concern

  included do
    # Add any OAuth-related validations or associations here
  end

  def oauth_connected?
    provider.present? && uid.present?
  end

  def update_oauth_attributes!(auth)
    update!(
      provider: auth.provider,
      uid: auth.uid,
      name: auth.info.name,
      avatar_url: auth.info.image
    )
  end

  module ClassMethods
    def from_omniauth(auth)
      # Try to find an existing user by provider/uid or email
      user = find_by(provider: auth.provider, uid: auth.uid) || 
             find_by(email: auth.info.email)

      if user
        # Update OAuth credentials if user exists
        user.update_oauth_attributes!(auth)
      else
        # Create new user if none exists
        user = create!(
          email: auth.info.email,
          password: Devise.friendly_token[0, 20],
          provider: auth.provider,
          uid: auth.uid,
          name: auth.info.name,
          avatar_url: auth.info.image
        )
      end

      user
    rescue ActiveRecord::RecordInvalid => e
      # Handle missing email case
      if auth.info.email.blank?
        user = new
        user.errors.add(:email, :blank, message: 'Email address is required')
        return user
      end
      raise e
    end
  end
end 