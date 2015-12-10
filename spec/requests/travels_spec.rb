require 'rails_helper'

RSpec.describe 'Travels', type: :request do

  describe 'GET #index' do

     context 'the user has travels' do
      before (:each) do
        @user = FactoryGirl.create(:user)
        @travel = FactoryGirl.create(:travel, user_id: @user.id)
        get user_travels_path(@user), format: :jbuilder
      end

      it 'returns a JSON with the travels' do
        data = JSON.parse(response.body)
        expect(data['travels'].length).to eq(1)
      end
     end

     context 'the user doesn´t have travels' do
      before (:each) do
        @user = FactoryGirl.create(:user)
        get user_travels_path(@user), format: :jbuilder
      end

      it 'respond with a 404 status code' do
        expect(response).to have_http_status(404)
      end

      it 'respond with an error json' do
        expect(response.body).to eq('The user doesn´t have any travel!')
      end
     end

  end

  describe 'GET #show' do

    context 'the travel exists' do
      before (:each) do
        @user = FactoryGirl.create(:user)
        @travel = FactoryGirl.create(:travel, title: 'European Tour', user_id: @user.id)
        get user_travel_path(@user, @travel), format: :jbuilder
      end
    
      it 'gets the correct travel' do
        data = JSON.parse(response.body)
        expect(data['title']).to eq('European Tour')
      end

    end

    context 'the travel does not exist' do
      before (:each) do
        @user = FactoryGirl.create(:user)
        get user_travel_path(@user, 10)
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
        @user = FactoryGirl.create(:user)
        @invalid_travel = FactoryGirl.build(:invalid_travel)
        post user_travels_path(@user), {:travel => @invalid_travel, :countries => '', :places => ''}
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
        @user = FactoryGirl.create(:user)
        @travel = FactoryGirl.build(:travel)
        post user_travels_path(@user), {title: 'Spain Tour', initial_date: @travel.initial_date, final_date:@travel.final_date, description: @travel.description, budget: @travel.budget, maximum_people: @travel.maximum_people, countries: '', places: ''}
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

      it 'the new travel belongs to the user' do
        expect(Travel.last.user_id).to eq(@user.id)
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'the travel exists' do
      before (:each) do
        @user = FactoryGirl.create(:user)
        @travel = FactoryGirl.create(:travel, user_id: @user.id)
        @count = Travel.count
        delete user_travel_path(@user, @travel)
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
        @user = FactoryGirl.create(:user)
        @count = Travel.count
        delete user_travel_path(@user, 10)
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
        @user = FactoryGirl.create(:user)
        @travel = FactoryGirl.create(:travel, title: 'European Tour', user_id: @user.id)

        patch user_travel_path(@user, @travel), {title: '', initial_date: @travel.initial_date, final_date:@travel.final_date, description: @travel.description, budget: @travel.budget, maximum_people: @travel.maximum_people, countries: '', places: ''}
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
        @user = FactoryGirl.create(:user)
        @travel = FactoryGirl.create(:travel, title: 'European Tour', user_id: @user.id)
        @travel.add_tags(['adventure'])
        @travel.add_places('Madrid')
      end

      it 'update the attributes of the travel' do
        patch user_travel_path(@user, @travel), {:travel => @travel.id, :title => 'Spain Tour', format: :jbuilder}
        expect(Travel.find_by(id: @travel.id).title).to eq('Spain Tour')
      end

      it 'delete the tag if the user deletes it' do
        patch user_travel_path(@user, @travel), {:travel => @travel.id, :title => 'Spain Tour', format: :jbuilder}
        expect(Travel.find_by(id: @travel.id).tags.count).to eq(0)
      end

      it 'add the tag the user checks' do
        patch user_travel_path(@user, @travel), {:travel => @travel.id, :title => 'Spain Tour', :tags => ['adventure', 'cruise'], format: :jbuilder}
        expect(Travel.find_by(id: @travel.id).tags.count).to eq(2)
      end

      it 'delete the place if the user deletes it' do
        patch user_travel_path(@user, @travel), {:travel => @travel.id, :title => 'Spain Tour', format: :jbuilder}
        expect(Travel.find_by(id: @travel.id).places.count).to eq(0)
      end

      it 'add the place the user enters' do
        patch user_travel_path(@user, @travel), {:travel => @travel.id, :title => 'Spain Tour', :places => 'Madrid,Sevilla', format: :jbuilder}
        expect(Travel.find_by(id: @travel.id).places.count).to eq(2)
      end

    end

  end


end