def login
  @user = FactoryGirl.create(:user)
  @traveler = FactoryGirl.create(:traveler, user_id: @user.id, first_name:'Maria')
  @travel = FactoryGirl.create(:travel, title: 'Madrid',user_id: @user.id)
  visit '/'
  fill_in('login_user_email', :with => @user.email)
  fill_in('login_user_password', :with => '12345678')
  click_button 'Log in'
end