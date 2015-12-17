require 'rails_helper'

feature 'a user deletes a traveler' do
  background do
    login
  end

  scenario 'it delete the traveler', :js => true do
    click_link('Delete')
    expect(page).not_to have_content('Maria')
  end
end



