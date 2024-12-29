require 'rails_helper'

RSpec.describe Capability, type: :model do
  describe 'validations' do
    subject { create(:capability, name: 'pilot') }
    
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_inclusion_of(:name).in_array(['pilot', 'passenger']) }
  end

  describe 'associations' do
    it { should have_many(:user_capabilities) }
    it { should have_many(:users).through(:user_capabilities) }
  end

  describe 'scopes' do
    let!(:pilot_capability) { create(:capability, name: 'pilot') }
    let!(:passenger_capability) { create(:capability, name: 'passenger') }

    it 'has a pilot scope' do
      expect(described_class.pilot).to eq(pilot_capability)
    end

    it 'has a passenger scope' do
      expect(described_class.passenger).to eq(passenger_capability)
    end
  end
end 