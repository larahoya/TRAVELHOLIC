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
        @traveler = FactoryGirl.create(:traveler)
        @user.travelers << @traveler
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
        @traveler = FactoryGirl.create(:traveler)
        @user.travelers << @traveler
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

  describe 'POST #join' do

    context 'the travel exists' do

      context 'the traveler satisfy the requirements' do
        before (:each) do
          @user = FactoryGirl.create(:user, country: 'Spain')
          @travel = FactoryGirl.create(:travel, user_id: @user.id, id: 1)
          @travel.requirement_list.add(['only people from my country', 'not children'])
          @traveler = FactoryGirl.create(:traveler, country: 'Spain', date_of_birth: Date.new(1980,12,12))
          post '/travels/1/join', {id: @traveler.id}
        end

        it 'add the traveler to the travel' do
          expect(@travel.travelers.count).to eq(1)
        end

        it 'returns a 200 code status' do
          expect(response).to have_http_status(200)
        end
      end

      context 'the traveler doesn´t satisfy the requirements' do
        before (:each) do
          @user = FactoryGirl.create(:user, country: 'Spain')
          @travel = FactoryGirl.create(:travel, user_id: @user.id, id: 1)
          @travel.requirement_list.add(['only people from my country','not children'])
          @travel.save
          @traveler = FactoryGirl.create(:traveler, country: 'Spain', date_of_birth: Date.new(2010,12,12))
          post '/travels/1/join', {id: @traveler.id}
        end

        it 'doesn´t add the traveler to the travel' do
          expect(@travel.travelers.count).to eq(0)
        end

        it 'returns a 404 code status' do
          expect(response).to have_http_status(404)
        end
      end

      context 'the traveler is already included' do
        before (:each) do
          @user = FactoryGirl.create(:user, country: 'Spain')
          @travel = FactoryGirl.create(:travel, user_id: @user.id, id: 1)
          @travel.requirement_list.add(['only people from my country','not children'])
          @travel.save
          @traveler = FactoryGirl.create(:traveler, country: 'Spain', date_of_birth: Date.new(2010,12,12))
          @travel.travelers << @traveler
          post '/travels/1/join', {id: @traveler.id}
        end

        it 'doesn´t add the traveler to the travel' do
          expect(@travel.travelers.count).to eq(1)
        end

        it 'returns a 404 code status' do
          expect(response).to have_http_status(404)
        end
      end
    end

    context 'the travel doesn´t exist' do
      before (:each) do
        @traveler = FactoryGirl.create(:traveler, country: 'Spain', date_of_birth: Date.new(2010,12,12))
        post '/travels/1/join', {id: @traveler.id}
      end

      it 'returns a 404 code status' do
        expect(response).to have_http_status(404)
      end
    end

  end

  describe 'POST #left' do

    context 'the travel exists' do

      context 'the traveler is targeted to the trip' do
        before (:each) do
          @user = FactoryGirl.create(:user, country: 'Spain')
          @travel = FactoryGirl.create(:travel, user_id: @user.id, id: 1)
          @traveler = FactoryGirl.create(:traveler)
          @travel.travelers << @traveler
          @count = @travel.travelers.count
          post '/travels/1/left', {id: @traveler.id}
        end

        it 'delete the traveler from the travel' do
          expect(@travel.travelers.count).to eq(@count - 1)
        end

        it 'returns a 200 code status' do
          expect(response).to have_http_status(200)
        end
      end

      context 'the traveler isn´t targeted to the trip' do
        before (:each) do
          @user = FactoryGirl.create(:user, country: 'Spain')
          @travel = FactoryGirl.create(:travel, user_id: @user.id, id: 1)
          @traveler = FactoryGirl.create(:traveler)
          @count = @travel.travelers.count
          post '/travels/1/left', {id: @traveler.id}
        end

        it 'doesn´t delete the traveler from the travel' do
          expect(@travel.travelers.count).to eq(@count)
        end

        it 'returns a 404 code status' do
          expect(response).to have_http_status(404)
        end
      end 
    end

    context 'the travel doesn´t exist' do
      before (:each) do
          @traveler = FactoryGirl.create(:traveler)
          post '/travels/1/left', {id: @traveler.id}
        end

      it 'returns a 404 code status' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST #search' do
    before (:each) do
      @travel = FactoryGirl.create(:travel, final_date: Date.new(2010,10,10), budget: 'medium', initial_date: Date.new(2010,10,10))
      @travel.add_places('Madrid')
      @travel.add_countries('Spain')
      @travel.save
    end

    context 'there are travels that satisfies all the conditions' do
      it 'returns an array of travels' do
        post '/travels/search', {tags: '', budget: 'medium',initial_date: Date.today, country: 'Spain', place: 'Madrid', final_date: Date.new(2000,10,10), format: :jbuilder}
        data = JSON.parse(response.body)
        expect(data['travels'].length).to eq(1)
      end
    end
    context 'there aren´t travels that satisfies all the conditions' do
      it 'returns an empty array' do
        post '/travels/search', {tags: '', budget: 'low',initial_date: Date.today,country: 'France',place: 'Madrid',final_date: Date.new(2000,10,10), format: :jbuilder}
        expect(response).to have_http_status(404)
      end
    end
  end

end