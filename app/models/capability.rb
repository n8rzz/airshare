class Capability < ApplicationRecord
  validates :name, presence: true, uniqueness: true, inclusion: { in: ['pilot', 'passenger'] }

  has_many :user_capabilities, dependent: :destroy
  has_many :users, through: :user_capabilities

  scope :pilot, -> { find_by(name: 'pilot') }
  scope :passenger, -> { find_by(name: 'passenger') }
end 