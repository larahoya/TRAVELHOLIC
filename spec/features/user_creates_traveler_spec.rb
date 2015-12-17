require 'rails_helper'

feature 'a user delete a traveler from a travel' do
  background do
    login
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