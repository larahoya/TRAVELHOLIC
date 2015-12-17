require 'rails_helper'

feature 'a user creates a travel' do
  background do
    login
  end

  scenario 'entering some incorrect information', :js => true do
    
    click_link('link-form-new')

    expect(page).to have_content('Title')

    fill_in('Initial date', :with => Date.today)
    fill_in('Final date', :with => Date.today)
    fill_in('Max', :with => 10)
    click_button('btn-create')

    expect(page).to have_content("Title can't be blank")
  end

  scenario 'all the information is correct', :js => true do
    click_link('link-form-new')
    expect(page).to have_content('Title')

    fill_in('Title', :with => 'Madrid')
    fill_in('Initial date', :with => Date.today)
    fill_in('Final date', :with => Date.today)
    fill_in('Max', :with => 10)
    click_button('btn-create')

    expect(page).to have_content('Update!')
  end
end
