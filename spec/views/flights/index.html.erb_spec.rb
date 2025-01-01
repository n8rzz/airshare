require 'rails_helper'

RSpec.describe "flights/index", type: :view do
  let(:pilot) { create(:user, :pilot) }
  let(:passenger) { create(:user, :passenger) }
  let!(:flights) do
    [
      create(:flight, 
             origin: 'KSFO', 
             destination: 'KJFK', 
             departure_time: 1.day.from_now,
             estimated_arrival_time: 1.day.from_now + 6.hours),
      create(:flight, 
             origin: 'KLAX', 
             destination: 'KBOS', 
             departure_time: 2.days.from_now,
             estimated_arrival_time: 2.days.from_now + 6.hours)
    ]
  end

  before do
    assign(:flights, flights)
    without_partial_double_verification do
      allow(view).to receive(:current_user).and_return(passenger)
    end
  end

  it "renders the search form" do
    render

    assert_select "form[action=?][method=?]", flights_path, "get" do
      assert_select "input[name=?]", "search[query]"
      assert_select "input[name=?]", "search[date]"
      assert_select "input[value=?]", "Search Flights"
    end
  end

  it "displays flight information in a table" do
    render

    assert_select "table" do
      assert_select "thead" do
        assert_select "th", text: "Flight"
        assert_select "th", text: "Departure"
        assert_select "th", text: "Status"
        assert_select "th", text: "Aircraft"
        assert_select "th", text: "Pilot"
        assert_select "th", text: "Capacity"
        assert_select "th", text: "Actions"
      end

      assert_select "tbody" do
        flights.each do |flight|
          assert_select "tr" do
            # Flight route
            assert_select "td", text: /#{flight.origin} → #{flight.destination}/

            # Departure date and time
            assert_select "td", text: /#{flight.departure_time.strftime("%B %d, %Y")}/
            assert_select "td", text: /#{flight.departure_time.strftime("%I:%M %p")}/

            # Status badge
            assert_select "td span.rounded-full", text: flight.status.titleize

            # Aircraft info
            assert_select "td", text: /#{flight.aircraft.registration}/
            assert_select "td", text: /#{flight.aircraft.model}/

            # Pilot name
            assert_select "td", text: flight.pilot.name

            # Capacity
            assert_select "td", text: flight.capacity.to_s

            # Actions
            assert_select "td" do
              assert_select "a", text: "View"
              # As a passenger, shouldn't see edit/cancel
              assert_select "a", text: "Edit", count: 0
              assert_select "a", text: "Cancel", count: 0
            end
          end
        end
      end
    end
  end

  context "when viewed by the pilot" do
    before do
      without_partial_double_verification do
        allow(view).to receive(:current_user).and_return(flights.first.pilot)
      end
    end

    it "shows edit and cancel links for own flights" do
      render

      assert_select "tr" do
        assert_select "a", text: "Edit"
        assert_select "a", text: "Cancel"
      end
    end
  end
end 