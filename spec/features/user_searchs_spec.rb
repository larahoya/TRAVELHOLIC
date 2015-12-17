require 'rails_helper'

feature 'a user searchs' do
  background do
    @travel1 = FactoryGirl.create(:travel, title:'First travel', budget:'high')
    @travel2 = FactoryGirl.create(:travel)
    @travel3 = FactoryGirl.create(:travel)
    @travel4 = FactoryGirl.create(:travel)
    @travel5 = FactoryGirl.create(:travel, title:'Last travel')
    @user = FactoryGirl.create(:user)
    visit '/'
  end

  scenario 'search without any requirement', :js => true do
    click_button 'Search!'
    expect(page).to have_content('Last travel')
  end

  scenario 'there is no results', :js => true do
    fill_in('Country', :with => 'Madrid')
    click_button 'Search!'
    expect(page).to have_content('No results!')
  end

end