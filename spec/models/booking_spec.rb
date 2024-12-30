require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe 'associations' do
    it { should belong_to(:flight) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:status) }
  end

  describe 'callbacks' do
    it 'sets booking_date before validation on create' do
      booking = build(:booking, booking_date: nil)
      expect(booking.booking_date).to be_nil
      
      booking.valid?
      expect(booking.booking_date).to be_present
    end
  end

  describe 'custom validations' do
    let(:flight) { create(:flight, capacity: 2) }
    let(:booking) { build(:booking, flight: flight) }

    context 'flight_has_available_capacity' do
      it 'is valid when flight has available capacity' do
        expect(booking).to be_valid
      end

      it 'is invalid when flight is at capacity' do
        create_list(:booking, 2, flight: flight)
        expect(booking).not_to be_valid
        expect(booking.errors[:base]).to include('Flight is at full capacity')
      end

      it 'excludes itself when checking capacity for existing booking' do
        existing_booking = create(:booking, flight: flight)
        create(:booking, flight: flight)
        
        existing_booking.status = :confirmed
        expect(existing_booking).to be_valid
      end
    end
  end

  describe 'status' do
    let(:booking) { create(:booking) }

    it 'defaults to pending' do
      expect(booking.status).to eq('pending')
    end

    it 'can transition through different statuses' do
      expect(booking.pending?).to be true
      
      booking.confirmed!
      expect(booking.confirmed?).to be true
      
      booking.checked_in!
      expect(booking.checked_in?).to be true
      
      booking.cancelled!
      expect(booking.cancelled?).to be true
    end
  end
end
