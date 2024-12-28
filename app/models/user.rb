class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  validates :email, presence: true, uniqueness: true
  validates :admin, inclusion: { in: [true, false] }

  def admin?
    admin
  end

  def make_admin!
    update!(admin: true)
  end

  def revoke_admin!
    update!(admin: false)
  end

  def self.from_omniauth(auth)
    # Try to find an existing user by provider/uid or email
    user = find_by(provider: auth.provider, uid: auth.uid) || 
           find_by(email: auth.info.email)

    if user
      # Update OAuth credentials if user exists
      user.update!(
        provider: auth.provider,
        uid: auth.uid,
        name: auth.info.name,
        avatar_url: auth.info.image
      )
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
      user = User.new
      user.errors.add(:email, :blank, message: 'Email address is required')
      return user
    end
    raise e
  end
end
