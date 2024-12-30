require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /privacy-policy" do
    it "returns http success" do
      get privacy_policy_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /terms-of-service" do
    it "returns http success" do
      get terms_of_service_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /sitemap" do
    it "returns http success" do
      get sitemap_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /about" do
    it "returns http success" do
      get about_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /contact" do
    it "returns http success" do
      get contact_path
      expect(response).to have_http_status(:success)
    end
  end
end
