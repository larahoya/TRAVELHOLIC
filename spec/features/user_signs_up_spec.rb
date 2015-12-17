require 'rails_helper'

feature 'a user signs up' do
  background do
    visit '/'
  end

  scenario 'the form is rendered', :js => true do
    click_link('link-form-signup')
    expect(page).to have_content('Telephone')
  end

  scenario 'some input is incorrect or missing', :js => true do
    click_link('link-form-signup')

    fill_in('user_last_name', :with => 'Hoya')
    fill_in('user_country', :with => 'Spain')
    fill_in('Date of birth', :with => Date.today)
    fill_in('Email', :with => 'lara@gmail.com')
    choose('avatar', match: :first)
    fill_in('Password', :with => '12345678')
    fill_in('Password confirmation', :with => '12345678')

    click_button 'Sign up'

    expect(page).to have_content("first_name:can't be blank")
  end

  scenario 'everything is correct', :js => true do
    click_link('link-form-signup')

    fill_in('user_first_name', :with => 'Lara')
    fill_in('user_last_name', :with => 'Hoya')
    fill_in('user_country', :with => 'Spain')
    fill_in('Date of birth', :with => Date.today)
    fill_in('Email', :with => 'lara@gmail.com')
    choose('avatar', match: :first)
    fill_in('Password', :with => '12345678')
    fill_in('Password confirmation', :with => '12345678')

    click_button 'Sign up'
    
    expect(page).to have_content('Surname')
  end

end