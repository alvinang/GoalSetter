require 'spec_helper'

feature "admin powers" do

  let(:non_admin) { User.create!(username: "non_admin", password: "password", admin: false) }
  before(:each) do
    User.create!(username: "admin", password: "password", admin: true)
    visit new_session_url

    fill_in 'Username', with: 'admin'
    fill_in 'Password', with: 'password'
    click_button "Sign In"
  end

  it "can delete non-admin users" do
    visit user_url(non_admin)

    expect(page).to have_button 'Remove Account'
  end

  it "can delete other admin users" do
    User.create(username: "new_admin", password: "password", admin: true)
    new_admin = User.last
    visit user_url(new_admin)

    expect(page).to have_button 'Remove Account'
  end

  it "can view private goals" do
    non_admin.goals.create(name: "Private Goal", private: true)

    visit user_url(non_admin)
    expect(page).to have_content "Private Goal"
  end

  it "can delete any user's goal" do
    non_admin.goals.create(name: "Any user goal")

    visit user_url(non_admin)
    click_button 'Remove Goal'
    expect(page).not_to have_content 'Any user goal'
  end

end