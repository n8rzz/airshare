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
    capabilities.none?
  end

  def pilot?
    capabilities.exists?(name: 'pilot')
  end

  def passenger?
    capabilities.exists?(name: 'passenger')
  end

  def make_guest!
    capabilities.clear
    user_capabilities.reload
  end

  def update_capabilities(pilot: false, passenger: false)
    return make_guest! if pilot == false && passenger == false

    transaction do
      capabilities.clear
      capabilities << Capability.pilot if pilot
      capabilities << Capability.passenger if passenger
    end
  end
end
