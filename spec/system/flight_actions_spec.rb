require 'rails_helper'

RSpec.describe 'Flight Actions', type: :system do
  let(:pilot) { create(:user, :pilot) }
  let(:another_pilot) { create(:user, :pilot) }
  let(:regular_user) { create(:user) }
  
  let!(:pilot_flight) { create(:flight, pilot: pilot, status: 'scheduled', origin: 'LAX', destination: 'SFO') }
  let!(:another_pilot_flight) { create(:flight, pilot: another_pilot, status: 'scheduled', origin: 'JFK', destination: 'BOS') }
  let!(:in_air_flight) { create(:flight, pilot: pilot, status: 'in_air', origin: 'ORD', destination: 'DEN') }
  let!(:completed_flight) { create(:flight, pilot: pilot, status: 'completed', origin: 'SEA', destination: 'PDX') }

  describe 'viewing flight actions' do
    context 'when not logged in' do
      before { visit flights_path }

      it 'shows only view action for all flights' do
        expect(page).to have_link('View', count: 4)
        expect(page).not_to have_link('Edit')
        expect(page).not_to have_link('Cancel')
      end
    end

    context 'when logged in as the flight pilot' do
      before do
        sign_in pilot
        visit flights_path
      end

      it 'shows edit action only for own scheduled flights' do
        within(find('tr', text: 'LAX → SFO')) do
          expect(page).to have_link('Edit')
        end

        within(find('tr', text: 'JFK → BOS')) do
          expect(page).not_to have_link('Edit')
        end
      end

      it 'shows cancel action only for own scheduled flights' do
        within(find('tr', text: 'LAX → SFO')) do
          expect(page).to have_link('Cancel')
        end

        within(find('tr', text: 'JFK → BOS')) do
          expect(page).not_to have_link('Cancel')
        end
      end

      it 'does not show cancel action for in-air flights' do
        within(find('tr', text: 'ORD → DEN')) do
          expect(page).not_to have_link('Cancel')
        end
      end

      it 'does not show cancel action for completed flights' do
        within(find('tr', text: 'SEA → PDX')) do
          expect(page).not_to have_link('Cancel')
        end
      end
    end

    context 'when logged in as another pilot' do
      before do
        sign_in another_pilot
        visit flights_path
      end

      it 'cannot edit or cancel other pilots flights' do
        within(find('tr', text: 'LAX → SFO')) do
          expect(page).not_to have_link('Edit')
          expect(page).not_to have_link('Cancel')
        end
      end
    end

    context 'when logged in as a regular user' do
      before do
        sign_in regular_user
        visit flights_path
      end

      it 'shows only view action for all flights' do
        expect(page).to have_link('View', count: 4)
        expect(page).not_to have_link('Edit')
        expect(page).not_to have_link('Cancel')
      end
    end
  end
end 