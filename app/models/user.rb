class User < ApplicationRecord
  include PasswordResetLimitable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :owned_aircrafts, class_name: 'Aircraft', foreign_key: :owner_id, dependent: :destroy
  has_many :piloted_flights, class_name: 'Flight', foreign_key: :pilot_id, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :user_capabilities, dependent: :destroy
  has_many :capabilities, through: :user_capabilities

  # Alias methods for compatibility
  alias_method :flights, :piloted_flights
  alias_method :aircraft, :owned_aircrafts

  # Capability names for easy reference and validation
  VALID_CAPABILITIES = %w[pilot passenger].freeze

  # Validate that capabilities are valid
  validate :validate_capabilities

  def admin?
    admin
  end

  def make_admin!
    update!(admin: true)
  end

  def revoke_admin!
    update!(admin: false)
  end

  def guest?
    Rails.cache.fetch("#{cache_key_with_version}/guest") do
      capabilities_count.zero?
    end
  end

  def pilot?
    Rails.cache.fetch("#{cache_key_with_version}/pilot") do
      capabilities.exists?(name: 'pilot')
    end
  end

  def passenger?
    Rails.cache.fetch("#{cache_key_with_version}/passenger") do
      capabilities.exists?(name: 'passenger')
    end
  end

  def make_guest!
    transaction do
      user_capabilities.destroy_all  # Use destroy_all to ensure callbacks are triggered
      self.capabilities = []  # Ensure the association is cleared
      touch # Force cache key rotation
      save!
    end
  rescue StandardError => e
    errors.add(:base, e.message)
    false
  end

  def update_capabilities(capabilities = {})
    return true if capabilities.blank?
    
    transaction do
      user_capabilities.destroy_all  # Use destroy_all to ensure callbacks are triggered
      
      capabilities.each do |capability_name, value|
        next unless value == true || value == "1"
        capability = Capability.find_or_create_by!(name: capability_name.to_s)
        self.capabilities << capability if capability
      end
      
      touch # Force cache key rotation
      save!
    end
  rescue StandardError => e
    errors.add(:base, e.message)
    false
  end

  def self.from_omniauth(auth)
    if auth.info.email.blank?
      user = new
      user.errors.add(:email, :blank, message: 'Email address is required')
      return user
    end

    user = find_by(email: auth.info.email)
    
    if user
      user.update!(
        provider: auth.provider,
        uid: auth.uid,
        name: auth.info.name,
        avatar_url: auth.info.image
      )
      user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name
        user.avatar_url = auth.info.image
      end
    end
  end

  private

  def validate_capabilities
    invalid_capabilities = capabilities.pluck(:name) - VALID_CAPABILITIES
    if invalid_capabilities.any?
      errors.add(:capabilities, "contains invalid capabilities: #{invalid_capabilities.join(', ')}")
    end
  end
end
