class User < ApplicationRecord
  include OmniauthableUser

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :trackable, omniauth_providers: [:google_oauth2]

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
end
