require 'rails_helper'

feature 'a user logs out' do
  background do
    login
  end

  scenario 'the user logs out', :js => true do
    click_link('Log Out')
    expect(page).to have_content('Sign up')
  end
end