class Aircraft < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  validates :registration, presence: true, uniqueness: true
  validates :model, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :manufacture_date, presence: true
  validates :range_nm, presence: true, numericality: { greater_than: 0 }
  validate :owner_must_be_pilot

  def display_name
    "#{registration} (#{model})"
  end

  private

  def owner_must_be_pilot
    if owner.present? && !owner.pilot?
      errors.add(:owner, "must be a pilot")
    end
  end
end 