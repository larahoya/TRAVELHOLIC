require 'rails_helper'

feature 'a user delete a traveler from a travel' do
  background do
    login
    @travel = FactoryGirl.create(:travel, title: 'Barcelona',user_id: @user.id)
  end

  scenario 'it can left', :js => true do
    click_link('Home')
    click_button 'Search!'
    click_link('Madrid')
    click_button('JOIN')

    click_link('Left')

    expect(page).not_to have_content('Left')
  end
end