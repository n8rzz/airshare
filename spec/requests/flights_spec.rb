require 'rails_helper'

RSpec.describe FlightsController, type: :request do
  let(:pilot) { create(:user, :pilot) }
  let(:passenger) { create(:user, :passenger) }
  let(:aircraft) { create(:aircraft, owner: pilot) }
  let(:valid_attributes) do
    {
      origin: "KSFO",
      destination: "KJFK",
      departure_time: 1.day.from_now,
      estimated_arrival_time: 1.day.from_now + 6.hours,
      capacity: 4,
      aircraft_id: aircraft.id
    }
  end

  describe 'GET /flights' do
    it 'requires authentication' do
      get flights_path
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when authenticated' do
      before { sign_in passenger }

      it 'returns a successful response' do
        get flights_path
        expect(response).to be_successful
      end

      it 'only shows future flights' do
        past_flight = create(:flight, departure_time: 1.day.ago)
        future_flight = create(:flight, departure_time: 1.day.from_now)
        
        get flights_path
        expect(assigns(:flights)).to include(future_flight)
        expect(assigns(:flights)).not_to include(past_flight)
      end
    end
  end

  describe 'GET /flights/:id' do
    let(:flight) { create(:flight) }

    it 'requires authentication' do
      get flight_path(flight)
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when authenticated' do
      before { sign_in passenger }

      it 'returns a successful response' do
        get flight_path(flight)
        expect(response).to be_successful
      end

      it 'assigns the user\'s booking if it exists' do
        booking = create(:booking, flight: flight, user: passenger)
        get flight_path(flight)
        expect(assigns(:booking)).to eq(booking)
      end
    end
  end

  describe 'GET /flights/new' do
    it 'requires authentication' do
      get new_flight_path
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when authenticated as a passenger' do
      before { sign_in passenger }

      it 'redirects to flights path' do
        get new_flight_path
        expect(response).to redirect_to(flights_path)
        expect(flash[:alert]).to eq('Only pilots can manage flights.')
      end
    end

    context 'when authenticated as a pilot' do
      before { sign_in pilot }

      it 'returns a successful response' do
        get new_flight_path
        expect(response).to be_successful
      end
    end
  end

  describe 'POST /flights' do
    it 'requires authentication' do
      post flights_path, params: { flight: valid_attributes }
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when authenticated as a passenger' do
      before { sign_in passenger }

      it 'redirects to flights path' do
        post flights_path, params: { flight: valid_attributes }
        expect(response).to redirect_to(flights_path)
        expect(flash[:alert]).to eq('Only pilots can manage flights.')
      end
    end

    context 'when authenticated as a pilot' do
      before { sign_in pilot }

      context 'with valid parameters' do
        it 'creates a new Flight' do
          expect {
            post flights_path, params: { flight: valid_attributes }
          }.to change(Flight, :count).by(1)
        end

        it 'redirects to the created flight' do
          post flights_path, params: { flight: valid_attributes }
          expect(response).to redirect_to(flight_path(Flight.last))
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Flight' do
          expect {
            post flights_path, params: { flight: valid_attributes.merge(departure_time: nil) }
          }.not_to change(Flight, :count)
        end

        it 'renders the new template' do
          post flights_path, params: { flight: valid_attributes.merge(departure_time: nil) }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PATCH /flights/:id' do
    let(:flight) { create(:flight, pilot: pilot) }
    let(:new_attributes) { { destination: 'KBOS' } }

    it 'requires authentication' do
      patch flight_path(flight), params: { flight: new_attributes }
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when authenticated as a passenger' do
      before { sign_in passenger }

      it 'redirects to flights path' do
        patch flight_path(flight), params: { flight: new_attributes }
        expect(response).to redirect_to(flights_path)
        expect(flash[:alert]).to eq('Only pilots can manage flights.')
      end
    end

    context 'when authenticated as a different pilot' do
      let(:other_pilot) { create(:user, :pilot) }
      before { sign_in other_pilot }

      it 'redirects to flights path' do
        patch flight_path(flight), params: { flight: new_attributes }
        expect(response).to redirect_to(flights_path)
        expect(flash[:alert]).to eq('You can only manage your own flights.')
      end
    end

    context 'when authenticated as the flight\'s pilot' do
      before { sign_in pilot }

      context 'with valid parameters' do
        it 'updates the flight' do
          patch flight_path(flight), params: { flight: new_attributes }
          flight.reload
          expect(flight.destination).to eq('KBOS')
        end

        it 'redirects to the flight' do
          patch flight_path(flight), params: { flight: new_attributes }
          expect(response).to redirect_to(flight_path(flight))
        end
      end

      context 'with invalid parameters' do
        it 'renders the edit template' do
          patch flight_path(flight), params: { flight: { departure_time: nil } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'DELETE /flights/:id' do
    let!(:flight) { create(:flight, pilot: pilot) }

    it 'requires authentication' do
      delete flight_path(flight)
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when authenticated as a passenger' do
      before { sign_in passenger }

      it 'redirects to flights path' do
        delete flight_path(flight)
        expect(response).to redirect_to(flights_path)
        expect(flash[:alert]).to eq('Only pilots can manage flights.')
      end
    end

    context 'when authenticated as a different pilot' do
      let(:other_pilot) { create(:user, :pilot) }
      before { sign_in other_pilot }

      it 'redirects to flights path' do
        delete flight_path(flight)
        expect(response).to redirect_to(flights_path)
        expect(flash[:alert]).to eq('You can only manage your own flights.')
      end
    end

    context 'when authenticated as the flight\'s pilot' do
      before { sign_in pilot }

      it 'destroys the flight' do
        expect {
          delete flight_path(flight)
        }.to change(Flight, :count).by(-1)
      end

      it 'redirects to the flights list' do
        delete flight_path(flight)
        expect(response).to redirect_to(flights_url)
      end
    end
  end
end
