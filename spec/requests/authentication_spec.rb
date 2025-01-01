require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'sign in flow' do
    let(:pilot) { create(:user, :pilot) }
    let!(:pilot_flight) { create(:flight, pilot: pilot, status: 'scheduled') }

    it 'shows appropriate actions before and after login' do
      # First visit as a non-logged in user
      get flights_path
      expect(response).to have_http_status(:success)
      expect(response.body).not_to include('Edit')
      expect(response.body).not_to include('Cancel')

      # Sign in and visit again
      sign_in pilot
      get flights_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Edit')
      expect(response.body).to include('Cancel')
    end

    it 'maintains access to requested page after login' do
      # Visit flights page first
      get flights_path
      expect(response.body).not_to include('Edit')
      
      # Sign in and verify we can still access flights
      sign_in pilot
      get flights_path
      expect(response.body).to include('Edit')
    end

    it 'allows accessing root after direct login' do
      # Sign in without visiting any page first
      sign_in pilot
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end 