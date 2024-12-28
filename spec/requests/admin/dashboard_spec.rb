require 'rails_helper'

RSpec.describe "Admin::Dashboards", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }

  describe "GET /admin" do
    context "when signed in as admin" do
      before { sign_in admin }

      it "returns http success" do
        get "/admin"
        expect(response).to have_http_status(:success)
      end
    end

    context "when signed in as regular user" do
      before { sign_in user }

      it "redirects to root path" do
        get "/admin"
        expect(response).to redirect_to(root_path)
      end
    end

    context "when not signed in" do
      it "redirects to sign in page" do
        get "/admin"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
