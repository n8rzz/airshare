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
end
