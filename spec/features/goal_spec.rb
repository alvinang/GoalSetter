# encoding: utf-8
require "spec_helper"

feature "adding goals" do

  before(:each) do
    visit new_user_url
    login!('Sign Up')
    visit new_goal_url
  end

  it "only logged in users can add goals" do
    click_button('Sign Out')
    visit new_goal_url
    expect(page).to have_content 'Sign In'
  end

  it "lets user set private goals" do
    expect(page).to have_content "Private"
    expect { check('Private') }.to_not raise_error
  end

  it "doesn't let user create a goal without a name" do
    click_button('Add Goal')
    expect(page).to have_content "Name can't be blank"
  end

  it "adds the goal to the user's show page on submit" do
    fill_in('What is your goal?', :with => 'Lose weight')
    click_button('Add Goal')
    expect(page).to have_content 'Goals for hello_world'
    expect(page).to have_content 'Lose weight'
  end

  it "user can add new goals from profile page" do
    visit user_url(User.last)
    expect(page).to have_link 'Add New Goal'
  end

end

feature "showing goals" do

  before(:each) do
    visit new_user_url
    login!('Sign Up')
    visit new_goal_url
  end

  it "shows all public goals on goals index page" do
    fill_in('What is your goal?', :with => 'Lose weight')
    click_button('Add Goal')
    visit goals_url
    expect(page).to have_content 'Lose weight'
  end

  it "shows user their own private goals" do
    fill_in('What is your goal?', :with => 'Lose weight')
    check('Private')
    click_button 'Add Goal'

    expect(page).to have_content 'Lose weight'
  end

  it "does not show private goals on all goals page" do
    fill_in('What is your goal?', :with => 'Lose weight')
    check('Private')
    click_button 'Add Goal'
    click_button 'Sign Out'

    visit new_user_url
    fill_in 'Username', with: 'bye_world'
    fill_in 'Password', with: 'password'
    click_button "Sign Up"

    visit goals_url
    expect(page).not_to have_content 'Lose weight'
  end

  it "does not reveal private goals on user profile page to other users" do
    fill_in('What is your goal?', :with => 'Lose weight')
    check('Private')
    click_button 'Add Goal'
    click_button 'Sign Out'
    user = User.last

    visit new_user_url
    fill_in 'Username', with: 'bye_world'
    fill_in 'Password', with: 'password'
    click_button "Sign Up"

    visit user_url(user)
    expect(page).not_to have_content 'Lose weight'
  end
end

feature "edit goals" do

  before(:each) do
    visit new_user_url
    login!('Sign Up')
    visit new_goal_url

    fill_in('What is your goal?', :with => 'Lose weight')
    click_button 'Add Goal'
  end

  it "lets user edit their own goals" do
    click_link 'Edit'
    fill_in('What is your goal?', :with => 'Get fat')
    click_button 'Update Goal'
    expect(page).to have_content 'Get fat'
  end

  it "doesn't let user edit another user's goals" do
    click_button 'Sign Out'

    visit new_user_url
    fill_in 'Username', with: 'bye_world'
    fill_in 'Password', with: 'password'
    click_button "Sign Up"

    visit goals_url
    expect(page).not_to have_content 'Edit'
  end

end

feature "completing goals" do

  before(:each) do
    visit new_user_url
    login!('Sign Up')
    visit new_goal_url

    fill_in('What is your goal?', :with => 'Lose weight')
    click_button 'Add Goal'
  end

  it "lets user check off completed goals" do
    click_button "✓"
    expect(page).to have_css('input.btn-complete')
  end
end