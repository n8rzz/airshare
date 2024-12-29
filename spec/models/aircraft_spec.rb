require 'rails_helper'

RSpec.describe Aircraft, type: :model do
  describe 'validations' do
    subject { build(:aircraft) }

    it { should validate_presence_of(:registration) }
    it { should validate_presence_of(:model) }
    it { should validate_presence_of(:capacity) }
    it { should validate_numericality_of(:capacity).only_integer.is_greater_than(0) }
    it { should validate_presence_of(:manufacture_date) }
    it { should validate_presence_of(:range_nm) }
    it { should validate_numericality_of(:range_nm).is_greater_than(0) }

    describe 'registration uniqueness' do
      let!(:existing_aircraft) { create(:aircraft) }
      let(:new_aircraft) { build(:aircraft, registration: existing_aircraft.registration) }

      it 'validates uniqueness of registration' do
        expect(new_aircraft).not_to be_valid
        expect(new_aircraft.errors[:registration]).to include('has already been taken')
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:owner).class_name('User') }
  end

  describe 'owner validation' do
    let(:passenger) { create(:user, :passenger) }
    let(:pilot) { create(:user, :pilot) }
    let(:aircraft) { build(:aircraft) }

    it 'is invalid when owner is not a pilot' do
      aircraft.owner = passenger
      expect(aircraft).not_to be_valid
      expect(aircraft.errors[:owner]).to include('must be a pilot')
    end

    it 'is valid when owner is a pilot' do
      aircraft.owner = pilot
      expect(aircraft).to be_valid
    end

    it 'is invalid when owner is nil' do
      aircraft.owner = nil
      expect(aircraft).not_to be_valid
      expect(aircraft.errors[:owner]).to include('must exist')
    end
  end

  describe 'factory' do
    it 'has a valid default factory' do
      expect(build(:aircraft)).to be_valid
    end

    it 'has a valid long_range factory' do
      expect(build(:aircraft, :long_range)).to be_valid
    end

    it 'has a valid vintage factory' do
      expect(build(:aircraft, :vintage)).to be_valid
    end
  end
end 