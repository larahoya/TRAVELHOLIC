require 'rails_helper'

feature 'a user joins a traveler to the travel' do
  background do
    login
  end

  scenario 'it can join', :js => true do
    click_link('Home')
    click_button 'Search!'
    click_link('Madrid')
    click_button('JOIN')

    expect(page).to have_content('Left')
  end
end