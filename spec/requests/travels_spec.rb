require 'rails_helper'

RSpec.describe 'Travels', type: :request do

  describe 'GET #show' do

    context 'the travel exists' do
      before (:each) do
        @travel = FactoryGirl.create(:travel, title: 'European Tour')
        get travel_path(@travel, format: :json)
      end
    
      it 'respond with a 200 status code' do
        expect(response).to have_http_status(200)
      end

      it 'gets the correct travel' do
        data = JSON.parse(response.body)
        expect(data['title']).to eq(@travel.title)
      end

    end

    context 'the travel does not exist' do
      before (:each) do
        get travel_path(10)
      end

      it 'respond with a 404 status code' do
        expect(response).to have_http_status(404)
      end

      it 'respond with an error json' do
        expect(response.body).to eq('The travel does not exist!')
      end

    end

  end

  describe 'POST #create' do

    context 'some attribute is missing or incorrect' do
    end

    context 'all the attributes are correct' do
    end

  end


end