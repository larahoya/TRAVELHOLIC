require 'rails_helper'

feature 'home page' do
  background do
    @travel1 = FactoryGirl.create(:travel, title:'First travel')
    @travel2 = FactoryGirl.create(:travel)
    @travel3 = FactoryGirl.create(:travel)
    @travel4 = FactoryGirl.create(:travel)
    @travel5 = FactoryGirl.create(:travel, title:'Last travel')
    @user = FactoryGirl.create(:user)

  end

  scenario 'rendering home page', :js => true do
    visit '/'
    expect(page).to have_content('Email')
  end

  scenario 'Log in', js: true do
    visit '/'
    fill_in('login_user_email', :with => @user.email)
    fill_in('login_user_password', :with => '12345678')
    click_button 'Log in'
    expect(page).to have_content('Log Out')
  end

  scenario 'Incorrect log in', js: true do
    visit '/'
    fill_in('login_user_email', :with => @user.email)
    fill_in('login_user_password', :with => '11111111')
    click_button 'Log in'
    expect(page).to have_content('Invalid')
  end

  scenario 'sign up a new user', :js => true do
    visit '/'
    click_link('link-form-signup')
    expect(page).to have_content('Telephone')
  end
end

feature 'not logged user' do
  background do
    @travel = FactoryGirl.create(:travel, title:'First travel')
  end
  scenario 'visiting a travel', :js => true do
    visit '/'
    click_link('First travel')

    expect(page).to have_content('Log in to comment!')
  end
end