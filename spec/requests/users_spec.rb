require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }
  let!(:pilot_capability) { Capability.find_or_create_by!(name: 'pilot') }
  let!(:passenger_capability) { Capability.find_or_create_by!(name: 'passenger') }

  before do
    sign_in user
  end

  describe 'GET /user' do
    it 'returns a successful response' do
      get user_path
      expect(response).to be_successful
    end

    it 'displays the user email' do
      get user_path
      expect(response.body).to include(user.email)
    end
  end

  describe 'PATCH /user' do
    context 'when updating capabilities' do
      it 'can add pilot capability' do
        patch user_path, params: { pilot: "1" }
        expect(user.reload).to be_pilot
        expect(response).to redirect_to("/user")
      end

      it 'can add passenger capability' do
        patch user_path, params: { passenger: "1" }
        expect(user.reload).to be_passenger
        expect(response).to redirect_to("/user")
      end

      it 'can add both pilot and passenger capabilities' do
        patch user_path, params: { pilot: "1", passenger: "1" }
        expect(user.reload).to be_pilot
        expect(user.reload).to be_passenger
        expect(response).to redirect_to("/user")
      end

      it 'can remove all capabilities' do
        user.capabilities << pilot_capability
        user.capabilities << passenger_capability
        
        patch user_path, params: {}
        expect(user.reload).to be_guest
        expect(response).to redirect_to("/user")
      end

      it 'can switch to guest mode' do
        user.capabilities << pilot_capability
        user.capabilities << passenger_capability
        
        patch user_path, params: { guest: "1" }
        expect(user.reload).to be_guest
        expect(response).to redirect_to("/user")
      end
    end

    it 'sets a success notice' do
      patch user_path, params: { pilot: "1" }
      expect(flash[:notice]).to eq('Capabilities updated successfully.')
    end
  end

  context 'when not signed in' do
    before do
      sign_out user
    end

    it 'redirects to sign in page when viewing profile' do
      get user_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to sign in page when updating capabilities' do
      patch user_path, params: { pilot: "1" }
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end 