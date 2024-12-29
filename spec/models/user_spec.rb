require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_inclusion_of(:admin).in_array([true, false]) }

    describe 'capability validation' do
      let(:user) { create(:user) }
      let(:pilot_capability) { create(:capability, name: 'pilot') }
      let(:passenger_capability) { create(:capability, name: 'passenger') }

      it 'allows valid capabilities' do
        user.capabilities << pilot_capability
        user.capabilities << passenger_capability
        expect(user).to be_valid
      end

      it 'rejects invalid capabilities' do
        # Mock an invalid capability name being returned
        allow(user.capabilities).to receive(:pluck).with(:name).and_return(['invalid_capability'])
        expect(user).not_to be_valid
        expect(user.errors[:capabilities]).to include("contains invalid capabilities: invalid_capability")
      end

      it 'validates against VALID_CAPABILITIES constant' do
        expect(User::VALID_CAPABILITIES).to contain_exactly('pilot', 'passenger')
      end

      it 'allows empty capabilities' do
        expect(user).to be_valid
      end
    end
  end

  describe 'defaults' do
    it 'sets admin to false by default' do
      user = User.new
      expect(user.admin).to be false
    end
  end

  describe 'admin methods' do
    let(:user) { create(:user) }

    describe '#admin?' do
      it 'returns true when user is admin' do
        user.admin = true
        expect(user.admin?).to be true
      end

      it 'returns false when user is not admin' do
        user.admin = false
        expect(user.admin?).to be false
      end
    end

    describe '#make_admin!' do
      it 'makes the user an admin' do
        user.make_admin!
        expect(user.reload.admin?).to be true
      end
    end

    describe '#revoke_admin!' do
      it 'revokes admin status' do
        user.admin = true
        user.save!
        user.revoke_admin!
        expect(user.reload.admin?).to be false
      end
    end
  end

  describe 'associations' do
    it { should have_many(:user_capabilities).dependent(:destroy) }
    it { should have_many(:capabilities).through(:user_capabilities) }
  end

  describe '#update_capabilities' do
    let(:user) { create(:user) }
    let!(:pilot_capability) { create(:capability, name: 'pilot') }
    let!(:passenger_capability) { create(:capability, name: 'passenger') }

    it 'adds pilot capability' do
      expect(user.update_capabilities(pilot: true)).to be true
      expect(user.reload.pilot?).to be true
      expect(user.passenger?).to be false
    end

    it 'adds passenger capability' do
      expect(user.update_capabilities(passenger: true)).to be true
      expect(user.reload.passenger?).to be true
      expect(user.pilot?).to be false
    end

    it 'adds both capabilities' do
      expect(user.update_capabilities(pilot: true, passenger: true)).to be true
      expect(user.reload.pilot?).to be true
      expect(user.passenger?).to be true
    end

    it 'removes all capabilities when neither is selected' do
      user.capabilities << pilot_capability << passenger_capability
      expect(user.update_capabilities(pilot: false, passenger: false)).to be true
      expect(user.reload.capabilities).to be_empty
    end
  end

  describe '#make_guest!' do
    let(:user) { create(:user) }
    let!(:pilot_capability) { create(:capability, name: 'pilot') }
    let!(:passenger_capability) { create(:capability, name: 'passenger') }

    before do
      user.capabilities << pilot_capability << passenger_capability
    end

    it 'removes all capabilities' do
      user.make_guest!
      expect(user.reload.capabilities).to be_empty
      expect(user).to be_guest
    end
  end

  describe 'capabilities' do
    let(:user) { create(:user) }
    let!(:pilot_capability) { create(:capability, name: 'pilot') }
    let!(:passenger_capability) { create(:capability, name: 'passenger') }

    describe '#guest?' do
      it 'returns true when user has no capabilities' do
        expect(user).to be_guest
      end

      it 'returns false when user has capabilities' do
        user.capabilities << pilot_capability
        expect(user).not_to be_guest
      end
    end

    describe '#pilot?' do
      it 'returns true when user has pilot capability' do
        user.capabilities << pilot_capability
        expect(user).to be_pilot
      end

      it 'returns false when user does not have pilot capability' do
        expect(user).not_to be_pilot
      end
    end

    describe '#passenger?' do
      it 'returns true when user has passenger capability' do
        user.capabilities << passenger_capability
        expect(user).to be_passenger
      end

      it 'returns false when user does not have passenger capability' do
        expect(user).not_to be_passenger
      end
    end

    describe '#make_guest!' do
      it 'removes all capabilities' do
        user.capabilities = [pilot_capability, passenger_capability]
        user.make_guest!
        expect(user.capabilities).to be_empty
      end
    end
  end
end
