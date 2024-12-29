require 'rails_helper'

RSpec.describe "Capability Selection", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "capability selection page" do
    before do
      visit new_capability_selection_path
    end

    it "displays the capability selection form" do
      expect(page).to have_content("Select Your Role")
      expect(page).to have_field("I want to be a pilot")
      expect(page).to have_field("I want to be a passenger")
      expect(page).to have_button("Save Preferences")
    end

    it "allows selecting pilot capability" do
      check "I want to be a pilot"
      click_button "Save Preferences"

      expect(user.reload.pilot?).to be true
      expect(page).to have_current_path(new_aircraft_path)
      expect(page).to have_content("Welcome, pilot!")
    end

    it "allows selecting passenger capability" do
      check "I want to be a passenger"
      click_button "Save Preferences"

      expect(user.reload.passenger?).to be true
      expect(page).to have_current_path(root_path)
      expect(page).to have_content("Capabilities updated successfully")
    end

    it "allows selecting both pilot and passenger capabilities" do
      check "I want to be a pilot"
      check "I want to be a passenger"
      click_button "Save Preferences"

      expect(user.reload.pilot?).to be true
      expect(user.passenger?).to be true
      expect(page).to have_current_path(new_aircraft_path)
      expect(page).to have_content("Welcome, pilot!")
    end
  end
end 