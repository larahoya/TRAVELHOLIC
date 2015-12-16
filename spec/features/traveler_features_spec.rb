require 'rails_helper'

feature 'create a traveler' do
  background do
    @user = FactoryGirl.create(:user)
    visit '/'
    fill_in('login_user_email', :with => @user.email)
    fill_in('login_user_password', :with => '12345678')
    click_button 'Log in'
  end

  scenario 'all the information is correct', :js => true do
    click_link('link-new-form-traveler')
    expect(page).to have_content('First name')

    fill_in('First name', :with => 'Lara')
    fill_in('Last name', :with => 'Hoya')
    fill_in('Country', :with => 'Spain')
    fill_in('Date of birth', :with => Date.today)
    choose('avatar', match: :first)

    click_button('btn-traveler-create')

    expect(page).to have_content('Delete')
  end

  scenario 'some information is missing or incorrect', :js => true do
    click_link('link-new-form-traveler')
    expect(page).to have_content('First name')

    fill_in('Last name', :with => 'Hoya')
    fill_in('Country', :with => 'Spain')
    fill_in('Date of birth', :with => Date.today)
    choose('avatar', match: :first)

    click_button('btn-traveler-create')

    expect(page).to have_content("First name can't be blank")
  end
end

feature 'delete a traveler' do
  background do
    @user = FactoryGirl.create(:user)
    @traveler = FactoryGirl.create(:traveler, user_id: @user.id, first_name: 'Lara')
    visit '/'
    fill_in('login_user_email', :with => @user.email)
    fill_in('login_user_password', :with => '12345678')
    click_button 'Log in'
  end

  scenario 'it delete the traveler', :js => true do
    click_link('Delete')
    expect(page).not_to have_content('Delete')
  end
end



