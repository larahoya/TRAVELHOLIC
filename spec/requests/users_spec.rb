require 'rails_helper'

RSpec.describe 'Travels', type: :request do

  describe 'GET #show' do

    context 'the user exists' do
      before (:each) do
        @user = FactoryGirl.create(:user, first_name: 'Lara')
        get user_path(@user), format: :jbuilder
      end
    
      it 'gets the correct user' do
        data = JSON.parse(response.body)
        expect(data['first_name']).to eq('Lara')
      end

    end

    context 'the user does not exist' do
      before (:each) do
        get user_path(100)
      end

      it 'respond with a 404 status code' do
        expect(response).to have_http_status(404)
      end

      it 'respond with an error json' do
        expect(response.body).to eq('User not found')
      end

    end
  end

end