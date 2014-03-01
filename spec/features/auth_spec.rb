require 'spec_helper'

feature "the signup process" do

  it "has a signup page" do
    visit new_user_url
    expect(page).to have_content 'Sign Up'
  end

  it "requires a username and password" do
    visit new_user_url
    click_button 'Sign Up'
    expect(page).to have_content "Username can't be blank"
  end

  it "requires a password to be longer than 6 characters" do
    visit new_user_url
    fill_in 'Username', with: 'hello_world'
    fill_in 'Password', with: 'pass'
    click_button 'Sign Up'
    expect(page).to have_content "Password is too short"
  end

  it "redirects to user's homepage after signup" do
    visit new_user_url
    login!("Sign Up")
    expect(page).to have_content 'hello_world'
  end


end

feature "logging in" do

  before(:each) do
    visit new_user_url
    login!("Sign Up")
    click_button "Sign Out"
  end

  context "when valid credentials" do
    it "logs in the user" do
      visit new_session_url
      login!("Sign In")
      expect(page).to have_content 'hello_world'
    end
  end

  context "when invalid credentials" do
    it "does not log in the user" do
      visit new_session_url
      fill_in 'Username', with: 'hello_world'
      fill_in 'Password', with: 'wrong_password'
      click_button "Sign In"
      expect(page).to have_content 'Username or password is invalid'
    end
  end
end

feature "logging out" do

  before :each do
    visit new_user_url
    login!("Sign Up")
  end

  it "displays signout button when logged in" do
    expect(page).to have_button "Sign Out"
  end

  it "doesn't display user information after logout" do
    click_button "Sign Out"
    expect(page).not_to have_content "hello_world"
  end
end