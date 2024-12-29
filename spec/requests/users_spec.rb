require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }
  let!(:pilot_capability) { create(:capability, name: 'pilot') }
  let!(:passenger_capability) { create(:capability, name: 'passenger') }

  before do
    sign_in user
  end

  describe "GET /user" do
    it "returns http success" do
      get "/user"
      expect(response).to have_http_status(:success)
    end

    it "shows current capabilities" do
      user.capabilities << pilot_capability
      get "/user"
      expect(response.body).to include('pilot')
    end
  end

  describe "PATCH /user" do
    context "with valid capabilities" do
      it "updates pilot capability" do
        patch "/user", params: { pilot: "1" }
        expect(response).to redirect_to("/user")
        expect(flash[:notice]).to eq('Capabilities updated successfully.')
        expect(user.reload.pilot?).to be true
      end

      it "updates passenger capability" do
        patch "/user", params: { passenger: "1" }
        expect(response).to redirect_to("/user")
        expect(flash[:notice]).to eq('Capabilities updated successfully.')
        expect(user.reload.passenger?).to be true
      end

      it "updates both capabilities" do
        patch "/user", params: { pilot: "1", passenger: "1" }
        expect(response).to redirect_to("/user")
        expect(flash[:notice]).to eq('Capabilities updated successfully.')
        expect(user.reload.pilot?).to be true
        expect(user.reload.passenger?).to be true
      end

      it "removes all capabilities" do
        user.capabilities << pilot_capability << passenger_capability
        patch "/user", params: { pilot: "0", passenger: "0" }
        expect(response).to redirect_to("/user")
        expect(flash[:notice]).to eq('Capabilities updated successfully.')
        expect(user.reload.capabilities).to be_empty
      end

      it "makes user a guest" do
        user.capabilities << pilot_capability << passenger_capability
        patch "/user", params: { guest: "1" }
        expect(response).to redirect_to("/user")
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
        patch "/user", params: { pilot: "1" }
        expect(response).to redirect_to("/user")
        expect(flash[:alert]).to eq("Invalid capabilities")
      end

      it "handles invalid capability combinations" do
        allow_any_instance_of(User).to receive(:errors).and_return(
          double(full_messages: ["Capabilities contains invalid capabilities"])
        )
        patch "/user", params: { pilot: "1", invalid: "1" }
        expect(response).to redirect_to("/user")
        expect(flash[:alert]).to eq("Capabilities contains invalid capabilities")
      end
    end

    context "when not authenticated" do
      before do
        sign_out user
      end

      it "redirects to sign in" do
        patch "/user", params: { pilot: "1" }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end 