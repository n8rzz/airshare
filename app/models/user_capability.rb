class UserCapability < ApplicationRecord
  belongs_to :user
  belongs_to :capability

  validates :user_id, uniqueness: { scope: :capability_id }
end 