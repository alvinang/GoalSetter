require 'spec_helper'

feature "the signup process" do

  it "has a new user page" do
    visit new_user_url
    expect(page).to have_content 'Sign Up'
  end

  feature "signing up a user" do
    it "shows username on the homepage after signup" do
      visit new_user_url
      login!("Sign Up")
      expect(page).to have_content 'hello_world'
    end
  end

end

feature "logging in" do

  it "shows username on the homepage after login" do
    visit new_user_url
    login!("Sign Up")
    click_button "Sign Out"

    visit new_session_url
    login!("Sign In")
    expect(page).to have_content 'hello_world'
  end

end

feature "logging out" do

  before :each do
    visit new_user_url
    login!("Sign Up")
  end

  it "begins with logged in state" do
    expect(page).to have_button "Sign Out"
  end

  it "doesn't show username on the homepage after logout" do
    click_button "Sign Out"
    expect(page).not_to have_content "hello_world"
  end

end