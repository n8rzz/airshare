require 'rails_helper'

RSpec.describe "Seeds" do
  before do
    load Rails.root.join('db/seeds.rb')
  end

  it "creates the correct number of users with proper attributes" do
    # Total users
    expect(User.count).to eq(6)

    # Admin users
    expect(User.where(admin: true).count).to eq(2)
    expect(User.find_by(email: 'starship@example.com')).to be_admin
    expect(User.find_by(email: 'oauth.admin@example.com')).to be_admin

    # Regular users
    expect(User.where(admin: false).count).to eq(4)
    expect(User.find_by(email: 'user1@example.com')).not_to be_admin
    expect(User.find_by(email: 'user2@example.com')).not_to be_admin
    expect(User.find_by(email: 'oauth.user1@example.com')).not_to be_admin
    expect(User.find_by(email: 'oauth.user2@example.com')).not_to be_admin

    # OAuth users
    oauth_users = User.where.not(provider: nil)
    expect(oauth_users.count).to eq(3)
    expect(oauth_users.pluck(:provider).uniq).to eq(['google_oauth2'])
  end

  it "sets correct capabilities_count for each user" do
    # Admin users should have 2 capabilities each
    expect(User.find_by(email: 'starship@example.com').capabilities_count).to eq(2)
    expect(User.find_by(email: 'oauth.admin@example.com').capabilities_count).to eq(2)

    # Regular users have varying capabilities
    expect(User.find_by(email: 'user1@example.com').capabilities_count).to eq(1) # pilot only
    expect(User.find_by(email: 'user2@example.com').capabilities_count).to eq(1) # passenger only
    expect(User.find_by(email: 'oauth.user1@example.com').capabilities_count).to eq(2) # both
    expect(User.find_by(email: 'oauth.user2@example.com').capabilities_count).to eq(0) # guest
  end
end 