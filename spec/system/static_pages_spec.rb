require 'rails_helper'

RSpec.describe "Static Pages", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "footer navigation" do
    it "displays footer on all pages" do
      visit root_path
      within("footer") do
        expect(page).to have_link("Privacy Policy")
        expect(page).to have_link("Terms of Service")
        expect(page).to have_link("About Us")
        expect(page).to have_link("Contact")
        expect(page).to have_link("Sitemap")
      end
    end
  end

  describe "Privacy Policy page" do
    it "displays privacy policy content" do
      visit privacy_policy_path
      expect(page).to have_content("Privacy Policy")
      expect(page).to have_content("Information We Collect")
      expect(page).to have_content("How We Use Your Information")
      expect(page).to have_content("Information Sharing")
      expect(page).to have_content("Data Security")
    end
  end

  describe "Terms of Service page" do
    it "displays terms of service content" do
      visit terms_of_service_path
      expect(page).to have_content("Terms of Service")
      expect(page).to have_content("Acceptance of Terms")
      expect(page).to have_content("User Accounts")
      expect(page).to have_content("Booking and Cancellation")
      expect(page).to have_content("Safety and Compliance")
    end
  end

  describe "About page" do
    it "displays about content" do
      visit about_path
      expect(page).to have_content("About AirShare")
      expect(page).to have_content("Our Mission")
      expect(page).to have_content("How It Works")
      expect(page).to have_content("Safety First")
      expect(page).to have_content("Community Values")
    end
  end

  describe "Contact page" do
    it "displays contact information and form" do
      visit contact_path
      expect(page).to have_content("Contact Us")
      expect(page).to have_content("Get in Touch")
      expect(page).to have_content("support@airshare.com")
      
      # Check form elements
      expect(page).to have_field("Name")
      expect(page).to have_field("Email")
      expect(page).to have_field("Subject")
      expect(page).to have_field("Message")
      expect(page).to have_button("Send Message")
    end
  end

  describe "Sitemap page" do
    context "when user is not signed in" do
      it "displays basic navigation links" do
        visit sitemap_path
        expect(page).to have_content("Sitemap")
        expect(page).to have_link("Home")
        expect(page).to have_link("Flights")
        expect(page).to have_link("Sign In")
        expect(page).to have_link("Sign Up")
        
        # Should not show restricted sections
        expect(page).not_to have_content("Pilot Features")
        expect(page).not_to have_content("Admin")
      end
    end

    context "when user is signed in as a pilot" do
      let(:pilot) { create(:user, :pilot) }

      before do
        sign_in pilot
      end

      it "displays pilot-specific navigation" do
        visit sitemap_path
        expect(page).to have_content("Pilot Features")
        expect(page).to have_link("My Aircraft")
        expect(page).to have_link("Create Flight")
      end
    end

    context "when user is signed in as an admin" do
      let(:admin) { create(:user, :admin) }

      before do
        sign_in admin
      end

      it "displays admin navigation" do
        visit sitemap_path
        expect(page).to have_content("Admin")
        expect(page).to have_link("Dashboard")
        expect(page).to have_link("Manage Users")
      end
    end
  end
end 