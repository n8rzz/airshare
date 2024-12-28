require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }

  before do
    sign_in admin
  end

  describe "GET /admin/users" do
    it "returns http success" do
      get "/admin/users"
      expect(response).to have_http_status(:success)
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
  end

  describe "GET /admin/users/:id/edit" do
    it "returns http success" do
      get "/admin/users/#{user.id}/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /admin/users/:id" do
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
