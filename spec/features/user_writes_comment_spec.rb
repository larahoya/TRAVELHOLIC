require 'rails_helper'

feature 'a user writes a comment' do
  background do
    login
  end

  scenario 'a user visits a travel and write a comment', :js => true  do
    click_link('Madrid')
    click_button('Write a comment')
    fill_in('public-description', :with => 'This is a comment')
    click_button('Save')

    expect(page).to have_content('This is a comment')
  end
end