require 'rails_helper'

RSpec.describe "Navigation", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "navigation bar shadow" do
    it "does not show shadow on sign in page" do
      visit new_user_session_path
      expect(page).to have_css("nav.bg-white:not(.shadow)")
    end

    it "shows shadow on other pages" do
      visit root_path
      expect(page).to have_css("nav.shadow")
    end
  end

  describe "authentication links" do
    context "when on sign in page" do
      it "does not show sign in/sign up links in navigation" do
        visit new_user_session_path
        within("nav") do
          expect(page).not_to have_link("Sign in")
          expect(page).not_to have_link("Sign up")
        end
      end
    end

    context "when on sign up page" do
      it "does not show sign in/sign up links in navigation" do
        visit new_user_registration_path
        within("nav") do
          expect(page).not_to have_link("Sign in")
          expect(page).not_to have_link("Sign up")
        end
      end
    end

    context "when on other pages" do
      it "shows sign in/sign up links for non-authenticated users" do
        visit root_path
        within("nav") do
          expect(page).to have_link("Sign in")
          expect(page).to have_link("Sign up")
        end
      end

      it "does not show sign in/sign up links for authenticated users" do
        user = create(:user)
        sign_in user
        visit root_path
        within("nav") do
          expect(page).not_to have_link("Sign in")
          expect(page).not_to have_link("Sign up")
        end
      end
    end
  end
end 