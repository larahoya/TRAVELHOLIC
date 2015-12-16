require 'rails_helper'

feature 'create a travel' do
  background do
    @user = FactoryGirl.create(:user)
    @traveler = FactoryGirl.create(:traveler, user_id: @user.id)
    visit '/'
    fill_in('login_user_email', :with => @user.email)
    fill_in('login_user_password', :with => '12345678')
    click_button 'Log in'
  end

  scenario 'all the information is correct', :js => true do
    click_link('link-form-new')
    expect(page).to have_content('Title')

    fill_in('Title', :with => 'Madrid')
    fill_in('Initial date', :with => Date.today)
    fill_in('Final date', :with => Date.today)
    fill_in('Max', :with => 10)
    click_button('btn-create')

    expect(page).to have_content('Update!')
  end

  scenario 'some information is missing', :js => true do
    click_link('link-form-new')
    expect(page).to have_content('Title')

    fill_in('Initial date', :with => Date.today)
    fill_in('Final date', :with => Date.today)
    fill_in('Max', :with => 10)
    click_button('btn-create')

    expect(page).to have_content("Title can't be blank")
  end
end

feature 'delete a travel' do
  background do
    @user = FactoryGirl.create(:user)
    @travel = FactoryGirl.create(:travel, title: 'Madrid',user_id: @user.id)
    visit '/'
    fill_in('login_user_email', :with => @user.email)
    fill_in('login_user_password', :with => '12345678')
    click_button 'Log in'
  end

  scenario 'delete the travel', :js => true do
    click_link('Madrid')
    expect(page).to have_content('Madrid')
    click_button('Delete!')

    expect(page).not_to have_content("Madrid")
  end
end

feature 'join a travel' do
  background do
    @user = FactoryGirl.create(:user)
    @traveler = FactoryGirl.create(:traveler, user_id: @user.id)
    @travel = FactoryGirl.create(:travel, title: 'Madrid')
    visit '/'
    fill_in('login_user_email', :with => @user.email)
    fill_in('login_user_password', :with => '12345678')
    click_button 'Log in'
    click_link('Home')
    click_button 'Search!'
    click_link('Madrid')
  end

  scenario 'it joins you to the travel', :js => true do
    click_link('Home')
    click_button 'Search!'
    click_link('Madrid')
    click_button('JOIN')

    expect(page).to have_content('Left')
  end
end

feature 'left a travel' do
  background do
    @user = FactoryGirl.create(:user)
    @traveler = FactoryGirl.create(:traveler, user_id: @user.id)
    @travel = FactoryGirl.create(:travel, title: 'Madrid')
    @travel.travelers << @traveler
    visit '/'
    fill_in('login_user_email', :with => @user.email)
    fill_in('login_user_password', :with => '12345678')
    click_button 'Log in'
  end

  scenario 'it joins you to the travel', :js => true do
    click_link('Home')
    click_button 'Search!'
    click_link('Madrid')
    click_link('Left')
    expect(page).not_to have_content('Left')
  end
end

feature 'write a comment' do
  background do
  end
end

