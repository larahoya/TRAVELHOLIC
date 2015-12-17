require 'rails_helper'

feature 'a user logs in' do
  background do
    @user = FactoryGirl.create(:user)
  end

  scenario 'rendering home page', :js => true do
    visit '/'
    expect(page).to have_content('Email')
  end

  scenario 'some input is incorrect', js: true do
    visit '/'
    fill_in('login_user_email', :with => @user.email)
    fill_in('login_user_password', :with => '11111111')
    click_button 'Log in'
    expect(page).to have_content('Invalid')
  end

  scenario 'everything is correct', js: true do
    visit '/'
    fill_in('login_user_email', :with => @user.email)
    fill_in('login_user_password', :with => '12345678')
    click_button 'Log in'
    expect(page).to have_content('Log Out')
  end

end