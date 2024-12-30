require 'rails_helper'

RSpec.describe BookingsController, type: :request do
  let(:passenger) { create(:user, :passenger) }
  let(:other_passenger) { create(:user, :passenger) }
  let(:flight) { create(:flight) }
  let(:valid_attributes) { { notes: 'Special meal request' } }

  describe 'GET /bookings' do
    it 'requires authentication' do
      get bookings_path
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when authenticated' do
      before { sign_in passenger }

      it 'returns a successful response' do
        get bookings_path
        expect(response).to be_successful
      end

      it 'lists only the user\'s bookings' do
        user_booking = create(:booking, user: passenger)
        other_booking = create(:booking, user: other_passenger)
        
        get bookings_path
        expect(assigns(:bookings)).to include(user_booking)
        expect(assigns(:bookings)).not_to include(other_booking)
      end
    end
  end

  describe 'GET /flights/:flight_id/bookings/new' do
    it 'requires authentication' do
      get new_flight_booking_path(flight)
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when authenticated as a pilot' do
      let(:pilot) { create(:user, :pilot) }
      before { sign_in pilot }

      it 'redirects to flights path' do
        get new_flight_booking_path(flight)
        expect(response).to redirect_to(flights_path)
        expect(flash[:alert]).to eq('You must be a passenger to book flights.')
      end
    end

    context 'when authenticated as a passenger' do
      before { sign_in passenger }

      it 'returns a successful response' do
        get new_flight_booking_path(flight)
        expect(response).to be_successful
      end

      it 'initializes a new booking' do
        get new_flight_booking_path(flight)
        expect(assigns(:booking)).to be_a_new(Booking)
        expect(assigns(:booking).flight).to eq(flight)
        expect(assigns(:booking).user).to eq(passenger)
      end
    end
  end

  describe 'POST /flights/:flight_id/bookings' do
    it 'requires authentication' do
      post flight_bookings_path(flight), params: { booking: valid_attributes }
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when authenticated as a pilot' do
      let(:pilot) { create(:user, :pilot) }
      before { sign_in pilot }

      it 'redirects to flights path' do
        post flight_bookings_path(flight), params: { booking: valid_attributes }
        expect(response).to redirect_to(flights_path)
        expect(flash[:alert]).to eq('You must be a passenger to book flights.')
      end
    end

    context 'when authenticated as a passenger' do
      before { sign_in passenger }

      context 'with valid parameters' do
        it 'creates a new Booking' do
          expect {
            post flight_bookings_path(flight), params: { booking: valid_attributes }
          }.to change(Booking, :count).by(1)
        end

        it 'creates a pending booking' do
          post flight_bookings_path(flight), params: { booking: valid_attributes }
          expect(Booking.last.status).to eq('pending')
        end

        it 'redirects to the created booking' do
          post flight_bookings_path(flight), params: { booking: valid_attributes }
          expect(response).to redirect_to(booking_path(Booking.last))
          expect(flash[:notice]).to eq('Booking was successfully created.')
        end
      end

      context 'when flight is at capacity' do
        before do
          flight.capacity.times { create(:booking, flight: flight) }
        end

        it 'does not create a new Booking' do
          expect {
            post flight_bookings_path(flight), params: { booking: valid_attributes }
          }.not_to change(Booking, :count)
        end

        it 'renders the new template with errors' do
          post flight_bookings_path(flight), params: { booking: valid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(assigns(:booking).errors[:base]).to include('Flight is at full capacity')
        end
      end
    end
  end

  describe 'GET /bookings/:id' do
    let(:booking) { create(:booking, user: passenger) }

    it 'requires authentication' do
      get booking_path(booking)
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when authenticated as a different user' do
      before { sign_in other_passenger }

      it 'redirects to bookings path' do
        get booking_path(booking)
        expect(response).to redirect_to(bookings_path)
        expect(flash[:alert]).to eq('You can only manage your own bookings.')
      end
    end

    context 'when authenticated as the booking owner' do
      before { sign_in passenger }

      it 'returns a successful response' do
        get booking_path(booking)
        expect(response).to be_successful
      end

      it 'assigns the requested booking' do
        get booking_path(booking)
        expect(assigns(:booking)).to eq(booking)
      end
    end
  end

  describe 'PATCH /bookings/:id/confirm' do
    let(:booking) { create(:booking, user: passenger, status: :pending) }

    it 'requires authentication' do
      patch confirm_booking_path(booking)
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when authenticated as a different user' do
      before { sign_in other_passenger }

      it 'redirects to bookings path' do
        patch confirm_booking_path(booking)
        expect(response).to redirect_to(bookings_path)
        expect(flash[:alert]).to eq('You can only manage your own bookings.')
      end
    end

    context 'when authenticated as the booking owner' do
      before { sign_in passenger }

      it 'confirms the booking' do
        patch confirm_booking_path(booking)
        expect(booking.reload.status).to eq('confirmed')
        expect(flash[:notice]).to eq('Booking was successfully confirmed.')
      end

      context 'when booking cannot be confirmed' do
        let(:booking) { create(:booking, user: passenger, status: :checked_in) }

        it 'does not confirm the booking' do
          patch confirm_booking_path(booking)
          expect(booking.reload.status).to eq('checked_in')
          expect(flash[:alert]).to eq('Booking cannot be confirmed.')
        end
      end
    end
  end

  describe 'PATCH /bookings/:id/check_in' do
    let(:booking) { create(:booking, user: passenger, status: :confirmed) }

    context 'when authenticated as the booking owner' do
      before { sign_in passenger }

      it 'checks in the booking' do
        patch check_in_booking_path(booking)
        expect(booking.reload.status).to eq('checked_in')
        expect(flash[:notice]).to eq('Successfully checked in.')
      end

      context 'when booking cannot be checked in' do
        let(:booking) { create(:booking, user: passenger, status: :pending) }

        it 'does not check in the booking' do
          patch check_in_booking_path(booking)
          expect(booking.reload.status).to eq('pending')
          expect(flash[:alert]).to eq('Booking cannot be checked in.')
        end
      end
    end
  end

  describe 'PATCH /bookings/:id/cancel' do
    let(:booking) { create(:booking, user: passenger, status: :confirmed) }

    context 'when authenticated as the booking owner' do
      before { sign_in passenger }

      it 'cancels the booking' do
        patch cancel_booking_path(booking)
        expect(booking.reload.status).to eq('cancelled')
        expect(flash[:notice]).to eq('Booking was successfully cancelled.')
      end

      context 'when booking cannot be cancelled' do
        let(:booking) { create(:booking, user: passenger, status: :checked_in) }

        it 'does not cancel the booking' do
          patch cancel_booking_path(booking)
          expect(booking.reload.status).to eq('checked_in')
          expect(flash[:alert]).to eq('Booking cannot be cancelled.')
        end
      end
    end
  end
end
