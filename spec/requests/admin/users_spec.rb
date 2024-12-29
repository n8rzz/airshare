require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let!(:pilot_capability) { create(:capability, name: 'pilot') }
  let!(:passenger_capability) { create(:capability, name: 'passenger') }

  before do
    sign_in admin
  end

  describe "GET /admin/users" do
    it "returns http success" do
      get "/admin/users"
      expect(response).to have_http_status(:success)
    end

    it "displays user capabilities" do
      user.capabilities << pilot_capability
      get "/admin/users"
      expect(response.body).to include('Pilot')
    end

    context "when signed in as regular user" do
      before { sign_in user }

      it "redirects to root path" do
        get "/admin/users"
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /admin/users/:id" do
    it "returns http success" do
      get "/admin/users/#{user.id}"
      expect(response).to have_http_status(:success)
    end

    it "displays user capabilities" do
      user.capabilities << pilot_capability
      get "/admin/users/#{user.id}"
      expect(response.body).to include('Pilot')
    end
  end

  describe "GET /admin/users/:id/edit" do
    it "returns http success" do
      get "/admin/users/#{user.id}/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /admin/users/:id" do
    context "with capability updates" do
      it "updates pilot capability" do
        patch "/admin/users/#{user.id}", params: { user: { capabilities: ['pilot'] } }
        expect(response).to redirect_to(admin_user_path(user))
        expect(flash[:notice]).to eq('User capabilities were successfully updated.')
        expect(user.reload.pilot?).to be true
      end

      it "updates passenger capability" do
        patch "/admin/users/#{user.id}", params: { user: { capabilities: ['passenger'] } }
        expect(response).to redirect_to(admin_user_path(user))
        expect(flash[:notice]).to eq('User capabilities were successfully updated.')
        expect(user.reload.passenger?).to be true
      end

      it "updates both capabilities" do
        patch "/admin/users/#{user.id}", params: { user: { capabilities: ['pilot', 'passenger'] } }
        expect(response).to redirect_to(admin_user_path(user))
        expect(flash[:notice]).to eq('User capabilities were successfully updated.')
        expect(user.reload.pilot?).to be true
        expect(user.reload.passenger?).to be true
      end

      it "makes user a guest" do
        user.capabilities << pilot_capability << passenger_capability
        patch "/admin/users/#{user.id}", params: { user: { guest: "1" } }
        expect(response).to redirect_to(admin_user_path(user))
        expect(flash[:notice]).to eq('User was successfully updated to guest.')
        expect(user.reload).to be_guest
      end

      it "handles validation errors" do
        allow(user).to receive(:update_capabilities).and_return(false)
        allow(user).to receive(:errors).and_return(
          double(full_messages: ["Invalid capabilities"], to_sentence: "Invalid capabilities")
        )
        allow(User).to receive(:find).with(user.id.to_s).and_return(user)
        
        patch "/admin/users/#{user.id}", params: { user: { capabilities: ['pilot'] } }
        expect(response).to redirect_to(admin_user_path(user))
        expect(flash[:alert]).to eq("Invalid capabilities")
      end
    end

    it "updates the user" do
      patch "/admin/users/#{user.id}", params: { user: { admin: true } }
      expect(response).to redirect_to(admin_user_path(user))
      expect(user.reload.admin).to be true
    end
  end

  describe "DELETE /admin/users/:id" do
    it "deletes the user" do
      delete "/admin/users/#{user.id}"
      expect(response).to redirect_to(admin_users_path)
      expect(User.exists?(user.id)).to be false
    end
  end

  describe "GET /admin/users/search" do
    it "returns http success" do
      get "/admin/users/search", params: { query: user.email }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/users/admins" do
    it "returns http success" do
      get "/admin/users/admins"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/users/regular_users" do
    it "returns http success" do
      get "/admin/users/regular_users"
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /admin/users/:id/toggle_admin" do
    it "toggles admin status" do
      patch "/admin/users/#{user.id}/toggle_admin"
      expect(response).to redirect_to(admin_user_path(user))
      expect(user.reload.admin).to be true
    end
  end
end
