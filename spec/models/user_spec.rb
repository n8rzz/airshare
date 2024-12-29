require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value(true).for(:admin) }
    it { should allow_value(false).for(:admin) }
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
