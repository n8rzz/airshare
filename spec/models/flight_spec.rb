require 'rails_helper'

RSpec.describe Flight, type: :model do
  describe 'associations' do
    it { should belong_to(:pilot).class_name('User') }
    it { should belong_to(:aircraft) }
    it { should have_many(:bookings).dependent(:destroy) }
    it { should have_many(:passengers).through(:bookings) }
  end

  describe 'validations' do
    it { should validate_presence_of(:origin) }
    it { should validate_presence_of(:destination) }
    it { should validate_presence_of(:departure_time) }
    it { should validate_presence_of(:estimated_arrival_time) }
    it { should validate_presence_of(:capacity) }
    it { should validate_numericality_of(:capacity).is_greater_than(0) }
  end

  describe 'custom validations' do
    let(:flight) { build(:flight) }

    context 'departure_time_in_future' do
      it 'is valid when departure time is in the future' do
        flight.departure_time = 1.day.from_now
        expect(flight).to be_valid
      end

      it 'is invalid when departure time is in the past' do
        flight.departure_time = 1.day.ago
        expect(flight).not_to be_valid
        expect(flight.errors[:departure_time]).to include('must be in the future')
      end
    end

    context 'arrival_after_departure' do
      it 'is valid when arrival time is after departure time' do
        flight.departure_time = 1.day.from_now
        flight.estimated_arrival_time = 2.days.from_now
        expect(flight).to be_valid
      end

      it 'is invalid when arrival time is before departure time' do
        flight.departure_time = 2.days.from_now
        flight.estimated_arrival_time = 1.day.from_now
        expect(flight).not_to be_valid
        expect(flight.errors[:estimated_arrival_time]).to include('must be after departure time')
      end
    end

    context 'capacity_within_aircraft_limit' do
      let(:aircraft) { create(:aircraft, capacity: 100) }
      
      before do
        flight.aircraft = aircraft
      end

      it 'is valid when capacity is within aircraft limit' do
        flight.capacity = 100
        expect(flight).to be_valid
      end

      it 'is invalid when capacity exceeds aircraft limit' do
        flight.capacity = 101
        expect(flight).not_to be_valid
        expect(flight.errors[:capacity]).to include('cannot exceed aircraft capacity')
      end
    end
  end

  describe 'status' do
    let(:flight) { create(:flight) }

    it 'defaults to scheduled' do
      expect(flight.status).to eq('scheduled')
    end

    it 'can transition through different statuses' do
      expect(flight.scheduled?).to be true
      
      flight.boarding!
      expect(flight.boarding?).to be true
      
      flight.in_air!
      expect(flight.in_air?).to be true
      
      flight.completed!
      expect(flight.completed?).to be true
    end
  end
end
