class UserCapability < ApplicationRecord
  belongs_to :user, counter_cache: :capabilities_count
  belongs_to :capability

  validates :user_id, uniqueness: { scope: :capability_id }
end 