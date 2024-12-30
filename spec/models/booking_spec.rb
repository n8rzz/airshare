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

  describe 'status transitions' do
    let(:booking) { create(:booking) }

    it 'defaults to pending' do
      expect(booking.status).to eq('pending')
    end

    context 'when pending' do
      let(:booking) { create(:booking, :pending) }

      it 'can be confirmed' do
        expect(booking.may_confirm?).to be true
        booking.confirmed!
        expect(booking.confirmed?).to be true
      end

      it 'can be cancelled' do
        expect(booking.may_cancel?).to be true
        booking.cancelled!
        expect(booking.cancelled?).to be true
      end

      it 'cannot be checked in' do
        expect(booking.may_check_in?).to be false
      end
    end

    context 'when confirmed' do
      let(:booking) { create(:booking, :confirmed) }

      it 'can be checked in' do
        expect(booking.may_check_in?).to be true
        booking.checked_in!
        expect(booking.checked_in?).to be true
      end

      it 'can be cancelled' do
        expect(booking.may_cancel?).to be true
        booking.cancelled!
        expect(booking.cancelled?).to be true
      end

      it 'cannot be confirmed again' do
        expect(booking.may_confirm?).to be false
      end
    end

    context 'when checked in' do
      let(:booking) { create(:booking, :checked_in) }

      it 'cannot be cancelled' do
        expect(booking.may_cancel?).to be false
      end

      it 'cannot be confirmed' do
        expect(booking.may_confirm?).to be false
      end

      it 'cannot be checked in again' do
        expect(booking.may_check_in?).to be false
      end
    end

    context 'when cancelled' do
      let(:booking) { create(:booking, :cancelled) }

      it 'cannot transition to any other status' do
        expect(booking.may_confirm?).to be false
        expect(booking.may_check_in?).to be false
        expect(booking.may_cancel?).to be false
      end
    end
  end

  describe 'scopes' do
    let!(:pending_booking) { create(:booking, :pending) }
    let!(:confirmed_booking) { create(:booking, :confirmed) }
    let!(:checked_in_booking) { create(:booking, :checked_in) }
    let!(:cancelled_booking) { create(:booking, :cancelled) }

    it 'filters active bookings' do
      active_bookings = Booking.where(status: [:pending, :confirmed, :checked_in])
      expect(active_bookings).to include(pending_booking, confirmed_booking, checked_in_booking)
      expect(active_bookings).not_to include(cancelled_booking)
    end

    it 'filters by status' do
      expect(Booking.where(status: :pending)).to contain_exactly(pending_booking)
      expect(Booking.where(status: :confirmed)).to contain_exactly(confirmed_booking)
      expect(Booking.where(status: :checked_in)).to contain_exactly(checked_in_booking)
      expect(Booking.where(status: :cancelled)).to contain_exactly(cancelled_booking)
    end
  end
end
