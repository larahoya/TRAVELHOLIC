require 'rails_helper'

RSpec.describe 'Travels', type: :request do

  describe 'GET #show' do

    context 'the travel exists' do
      before (:each) do
        @travel = FactoryGirl.create(:travel, title: 'European Tour')
        get travel_path(@travel)
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
      before (:each) do
        @invalid_travel = FactoryGirl.build(:invalid_travel)
        post travels_path, {:travel => @invalid_travel, :countries => '', :places => ''}
      end

      it 'respond with a 404 status code' do
        expect(response).to have_http_status(404)
      end

      it 'respond with the errors' do
        data = JSON.parse(response.body)
        expect(data[0]).to eq("Title can't be blank")
      end
    end

    context 'all the attributes are correct' do
      before (:each) do
        @travel = FactoryGirl.build(:travel)
        post travels_path, {title: 'Spain Tour', initial_date: @travel.initial_date, final_date:@travel.final_date, description: @travel.description, budget: @travel.budget, maximum_people: @travel.maximum_people, countries: '', places: ''}
      end

      it 'respond with a 201 status code' do
        expect(response).to have_http_status(201)
      end

      it 'respond with a JSON with the travel' do
        data = JSON.parse(response.body)
        expect(data['title']).to eq("Spain Tour")
      end

      it 'creates a new Travel' do
        expect(Travel.last.title).to eq("Spain Tour")
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'the travel exists' do
      before (:each) do
        @travel = FactoryGirl.create(:travel)
        @count = Travel.count
        delete travel_path(@travel)
      end

      it 'respond with a 204 status code' do
        expect(response).to have_http_status(204)
      end

      it 'delete the travel' do
        expect(Travel.count).to eq(@count-1)
      end
    end

    context 'the travel doesn´t exist' do
      before (:each) do
        @count = Travel.count
        delete travel_path(10)
      end

      it 'respond with a 404 status code' do
        expect(response).to have_http_status(404)
      end

      it 'respond with a JSON with an error message' do
        expect(response.body).to eq('The travel does not exist!')
      end

      it 'does not delete any travel' do
        expect(Travel.count).to eq(@count)
      end
    end
  end

  describe 'PATCH #update' do

    context 'some attribute is incorrect' do
      before (:each) do
        @travel = FactoryGirl.create(:travel, title: 'European Tour')

        patch travel_path(@travel), {title: '', initial_date: @travel.initial_date, final_date:@travel.final_date, description: @travel.description, budget: @travel.budget, maximum_people: @travel.maximum_people, countries: '', places: ''}
      end

      it 'respond with a 404 status code' do
        expect(response).to have_http_status(404)
      end

      it 'respond with a JSON with an error message' do
        expect(response.body).to eq('The travel couldn´t be updated!')
      end

      it 'does not update the travel' do
        expect(Travel.find_by(id: @travel.id).title).to eq('European Tour')
      end
    end

    context 'all the attributes are correct' do
      before (:each) do
        @travel = FactoryGirl.create(:travel, title: 'European Tour')
        patch travel_path(@travel), {title: 'Spain Tour', initial_date: @travel.initial_date, final_date:@travel.final_date, description: @travel.description, budget: @travel.budget, maximum_people: @travel.maximum_people, countries: '', places: ''}
      end

      it 'respond with a 200 status code' do
        expect(response).to have_http_status(200)
      end

      it 'respond with a JSON with the travel' do
        data = JSON.parse(response.body)
        expect(data['title']).to eq("Spain Tour")
      end

      it 'update the attributes of the travel' do
        expect(Travel.find_by(id: @travel.id).title).to eq('Spain Tour')
      end
    end

  end


end