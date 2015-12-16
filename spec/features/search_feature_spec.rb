require 'rails_helper'

feature 'searcher' do
  background do
    @travel1 = FactoryGirl.create(:travel, title:'First travel', budget:'high')
    @travel2 = FactoryGirl.create(:travel)
    @travel3 = FactoryGirl.create(:travel)
    @travel4 = FactoryGirl.create(:travel)
    @travel5 = FactoryGirl.create(:travel, title:'Last travel')
    @user = FactoryGirl.create(:user)

  end

  scenario 'rendering search', :js => true do
    visit '/'
    click_button 'Search!'
    expect(page).to have_content('Last travel')
  end

end