require 'rails_helper'

RSpec.describe "CapabilitySelection", type: :request do
  let(:user) { create(:user) }
  let!(:pilot_capability) { create(:capability, name: 'pilot') }
  let!(:passenger_capability) { create(:capability, name: 'passenger') }

  before do
    sign_in user
  end

  describe "GET /capability_selection/new" do
    it "returns http success" do
      get "/capability_selection/new"
      expect(response).to have_http_status(:success)
    end

    context "when not authenticated" do
      before do
        sign_out user
      end

      it "redirects to sign in" do
        get "/capability_selection/new"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /capability_selection" do
    context "with valid capabilities" do
      it "sets pilot capability" do
        post "/capability_selection", params: { pilot: "1" }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Capabilities updated successfully.')
        expect(user.reload.pilot?).to be true
      end

      it "sets passenger capability" do
        post "/capability_selection", params: { passenger: "1" }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Capabilities updated successfully.')
        expect(user.reload.passenger?).to be true
      end

      it "sets both capabilities" do
        post "/capability_selection", params: { pilot: "1", passenger: "1" }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Capabilities updated successfully.')
        expect(user.reload.pilot?).to be true
        expect(user.reload.passenger?).to be true
      end

      it "makes user a guest" do
        user.capabilities << pilot_capability << passenger_capability
        post "/capability_selection", params: { guest: "1" }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Capabilities updated successfully.')
        expect(user.reload).to be_guest
      end
    end

    context "with invalid capabilities" do
      before do
        allow_any_instance_of(User).to receive(:update_capabilities).and_return(false)
        allow_any_instance_of(User).to receive_message_chain(:errors, :full_messages, :to_sentence)
          .and_return("Invalid capabilities")
      end

      it "handles validation errors" do
        post "/capability_selection", params: { pilot: "1" }
        expect(response).to redirect_to(new_capability_selection_path)
        expect(flash[:alert]).to eq("Invalid capabilities")
      end
    end

    context "when not authenticated" do
      before do
        sign_out user
      end

      it "redirects to sign in" do
        post "/capability_selection", params: { pilot: "1" }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end 