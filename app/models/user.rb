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
    capabilities.empty?
  end

  def pilot?
    capabilities.exists?(name: 'pilot')
  end

  def passenger?
    capabilities.exists?(name: 'passenger')
  end

  def make_guest!
    capabilities.clear
    user_capabilities.destroy_all
    save!
  rescue StandardError => e
    errors.add(:base, e.message)
    false
  end

  def update_capabilities(capabilities = {})
    return true if capabilities.blank?
    
    user_capabilities.destroy_all
    
    capabilities.each do |capability_name, value|
      next unless value == true || value == "1"
      capability = Capability.find_by(name: capability_name.to_s)
      self.capabilities << capability if capability
    end
    
    save!
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
