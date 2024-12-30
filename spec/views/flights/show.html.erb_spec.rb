require 'rails_helper'

RSpec.describe "flights/show", type: :view do
  let(:pilot) { create(:user, :pilot) }
  let(:passenger) { create(:user, :passenger) }
  let(:flight) { create(:flight, pilot: pilot, status: 'scheduled') }

  before do
    assign(:flight, flight)
    assign(:booking, nil)
  end

  context "when viewed by the pilot" do
    before do
      without_partial_double_verification do
        allow(view).to receive(:current_user).and_return(pilot)
      end
    end

    it "shows status update buttons" do
      render

      Flight.statuses.keys.each do |status|
        next if status == flight.status
        assert_select "form[action=?]", update_status_flight_path(flight) do
          assert_select "input[type=hidden][name=status][value=?]", status
          assert_select "button[type=submit]", text: status.titleize
        end
      end
    end

    it "doesn't show a button for the current status" do
      render
      assert_select "button", text: flight.status.titleize, count: 0
    end
  end

  context "when viewed by a passenger" do
    before do
      without_partial_double_verification do
        allow(view).to receive(:current_user).and_return(passenger)
      end
    end

    it "doesn't show status update buttons" do
      render
      assert_select "form[action=?]", update_status_flight_path(flight), count: 0
    end
  end
end 