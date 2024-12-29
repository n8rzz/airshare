class User < ApplicationRecord
  include OmniauthableUser

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :trackable, omniauth_providers: [:google_oauth2]

  validates :email, presence: true, uniqueness: true
  validates :admin, inclusion: { in: [true, false] }

  has_many :user_capabilities, dependent: :destroy
  has_many :capabilities, through: :user_capabilities

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
        capability = Capability.find_by(name: capability_name.to_s)
        self.capabilities << capability if capability
      end
      
      touch # Force cache key rotation
      save!
    end
  rescue StandardError => e
    errors.add(:base, e.message)
    false
  end

  private

  def validate_capabilities
    invalid_capabilities = capabilities.pluck(:name) - VALID_CAPABILITIES
    if invalid_capabilities.any?
      errors.add(:capabilities, "contains invalid capabilities: #{invalid_capabilities.join(', ')}")
    end
  end
end
