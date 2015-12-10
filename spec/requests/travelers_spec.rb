require 'rails_helper'

RSpec.describe 'Travelers', type: :request do

  describe 'GET #index' do

     context 'the user has travelers' do
      before (:each) do
        @user = FactoryGirl.create(:user)
        @traveler = FactoryGirl.create(:traveler, user_id: @user.id)
        get user_travelers_path(@user), format: :jbuilder
      end

      it 'returns a JSON with the travelers' do
        data = JSON.parse(response.body)
        expect(data['travelers'].length).to eq(1)
      end
     end

     context 'the user doesn´t have travels' do
      before (:each) do
        @user = FactoryGirl.create(:user)
        get user_travelers_path(@user), format: :jbuilder
      end

      it 'respond with a 404 status code' do
        expect(response).to have_http_status(404)
      end

      it 'respond with an error json' do
        expect(response.body).to eq('The user doesn´t have any traveler!')
      end
     end

  end

  describe 'GET #show' do

    context 'the traveler exists' do
      before (:each) do
        @user = FactoryGirl.create(:user)
        @traveler = FactoryGirl.create(:traveler, first_name: 'Lara', user_id: @user.id)
        get user_traveler_path(@user, @traveler)
      end
    
      it 'gets the correct traveler' do
        data = JSON.parse(response.body)
        expect(data['first_name']).to eq('Lara')
      end

    end

    context 'the traveler does not exist' do
      before (:each) do
        @user = FactoryGirl.create(:user)
        get user_traveler_path(@user, 10)
      end

      it 'respond with a 404 status code' do
        expect(response).to have_http_status(404)
      end

      it 'respond with an error json' do
        expect(response.body).to eq('The traveler does not exist!')
      end

    end

  end

  describe 'POST #create' do

    context 'some attribute is missing or incorrect' do
      before (:each) do
        @user = FactoryGirl.create(:user)
        @traveler = FactoryGirl.build(:traveler)
        post user_travelers_path(@user), {:first_name => @traveler.first_name, :last_name => @traveler.last_name, :date_of_birth => @traveler.date_of_birth, :country => @traveler.country, :gender => ''}
      end

      it 'respond with a 404 status code' do
        expect(response).to have_http_status(404)
      end

      it 'respond with the errors' do
        data = JSON.parse(response.body)
        expect(data[0]).to eq("Gender can't be blank")
      end
    end

    context 'all the attributes are correct' do
      before (:each) do
        @user = FactoryGirl.create(:user)
        @traveler = FactoryGirl.build(:traveler)
        post user_travelers_path(@user), {:first_name => @traveler.first_name, :last_name => @traveler.last_name, :date_of_birth => @traveler.date_of_birth, :country => @traveler.country, :gender => @traveler.gender}
      end

      it 'respond with a 201 status code' do
        expect(response).to have_http_status(201)
      end

      it 'respond with a JSON with the traveler' do
        data = JSON.parse(response.body)
        expect(data['gender']).to eq("FEMALE")
      end

      it 'creates a new traveler' do
        expect(Traveler.last.gender).to eq("FEMALE")
      end

      it 'the new traveler belongs to the user' do
        expect(Traveler.last.user_id).to eq(@user.id)
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'the traveler exists' do
      before (:each) do
        @user = FactoryGirl.create(:user)
        @traveler = FactoryGirl.create(:traveler, user_id: @user.id)
        @count = Traveler.count
        delete user_traveler_path(@user, @traveler)
      end

      it 'respond with a 204 status code' do
        expect(response).to have_http_status(204)
      end

      it 'delete the traveler' do
        expect(Traveler.count).to eq(@count-1)
      end
    end

    context 'the traveler doesn´t exist' do
      before (:each) do
        @user = FactoryGirl.create(:user)
        @count = Traveler.count
        delete user_traveler_path(@user, 10)
      end

      it 'respond with a 404 status code' do
        expect(response).to have_http_status(404)
      end

      it 'respond with a JSON with an error message' do
        expect(response.body).to eq('The traveler does not exist!')
      end

      it 'does not delete any traveler' do
        expect(Traveler.count).to eq(@count)
      end
    end
  end

  describe 'PATCH #update' do

    context 'some attribute is incorrect' do
      before (:each) do
        @user = FactoryGirl.create(:user)
        @traveler = FactoryGirl.create(:traveler, first_name: 'Maria', user_id: @user.id)

        patch user_traveler_path(@user, @traveler), {:first_name => 'Lara', :last_name => @traveler.last_name, :date_of_birth => @traveler.date_of_birth, :country => @traveler.country, :gender => ''}
      end

      it 'respond with a 404 status code' do
        expect(response).to have_http_status(404)
      end

      it 'respond with a JSON with an error message' do
        expect(response.body).to eq('The traveler couldn´t be updated!')
      end

      it 'does not update the traveler' do
        expect(Traveler.find_by(id: @traveler.id).first_name).to eq('Maria')
      end
    end

    context 'all the attributes are correct' do
      before (:each) do
        @user = FactoryGirl.create(:user)
        @traveler = FactoryGirl.create(:traveler, first_name: 'Maria', user_id: @user.id)
        patch user_traveler_path(@user, @traveler), {:first_name => 'Lara', :last_name => @traveler.last_name, :date_of_birth => @traveler.date_of_birth, :country => @traveler.country, :gender => @traveler.gender}
      end

      it 'update the attributes of the travel' do
        expect(Traveler.find_by(id: @traveler.id).first_name).to eq('Lara')
      end

    end

  end


end