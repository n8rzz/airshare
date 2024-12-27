require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/users/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/admin/users/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/admin/users/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/admin/users/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/admin/users/destroy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /search" do
    it "returns http success" do
      get "/admin/users/search"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admins" do
    it "returns http success" do
      get "/admin/users/admins"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /regular_users" do
    it "returns http success" do
      get "/admin/users/regular_users"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /toggle_admin" do
    it "returns http success" do
      get "/admin/users/toggle_admin"
      expect(response).to have_http_status(:success)
    end
  end

end
