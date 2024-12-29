require 'rails_helper'

RSpec.describe "CapabilitySelection", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /capability_selection/new" do
    it "returns http success" do
      get new_capability_selection_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /capability_selection" do
    context "with valid capabilities" do
      context "when selecting pilot capability" do
        it "sets pilot capability" do
          expect {
            post capability_selection_path, params: { pilot: "1" }
          }.to change { user.reload.pilot? }.from(false).to(true)
        end

        it "redirects to new aircraft path" do
          post capability_selection_path, params: { pilot: "1" }
          expect(response).to redirect_to(new_aircraft_path)
        end
      end

      context "when selecting both capabilities" do
        it "sets both capabilities" do
          expect {
            post capability_selection_path, params: { pilot: "1", passenger: "1" }
          }.to change { user.reload.pilot? }.from(false).to(true)
            .and change { user.reload.passenger? }.from(false).to(true)
        end

        it "redirects to new aircraft path" do
          post capability_selection_path, params: { pilot: "1", passenger: "1" }
          expect(response).to redirect_to(new_aircraft_path)
        end
      end
    end
  end
end 