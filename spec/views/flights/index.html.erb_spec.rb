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
      assert_select "input[type=submit]"
    end
  end

  it "displays flight information" do
    render

    flights.each do |flight|
      assert_select "h3", text: /#{flight.origin}.*#{flight.destination}/
      assert_select "p", text: /#{flight.departure_time.strftime("%B %d, %Y")}/
    end
  end
end 