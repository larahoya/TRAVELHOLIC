require 'rails_helper'

RSpec.describe 'Comments', type: :request do

  describe 'GET #index' do

    context 'the comment exists' do
      before (:each) do
        @travel = FactoryGirl.create(:travel)
        @comment = FactoryGirl.create(:comment, description: 'This is a comment', travel_id: @travel.id)
        get travel_comments_path(@travel), format: :jbuilder
      end

      it 'returns a json with the comments' do
        data = JSON.parse(response.body)
        expect(data['comments'].length).to eq(1)
      end

      it 'returns the comments that belongs to the travel' do
        data = JSON.parse(response.body)
        expect(data['comments'][0]['description']).to eq('This is a comment')
      end
    end

    context 'the travel doesn´t have comments' do
      before (:each) do
        @travel = FactoryGirl.create(:travel)
        get travel_comments_path(@travel), format: :jbuilder
      end

      it 'respond with a 404 status code' do
        expect(response).to have_http_status(404)
      end

      it 'respond with an error json' do
        expect(response.body).to eq('The travel doesn´t have any comment!')
      end
      
    end
  end

  describe 'POST #create' do
    context 'all the attributes are correct' do
      it 'returns a json with the comment' do
      end
      it 'creates a comment' do
      end
    end

    context 'some attribute is missing or incorrect' do
      it 'respond with a 404 status code' do
        expect(response).to have_http_status(404)
      end
      it 'respond with an error json' do
        expect(response.body).to eq('The comment could´t be created!')
      end
    end
  end

  describe 'DESTROY #delete' do
    context 'the comment exists' do
      it 'respond with a 204 status code' do
        expect(response).to have_http_status(204)
      end

      it 'delete the comment' do
        expect(Comment.count).to eq(@count-1)
      end
    end

    context 'the comment doesn´t exist' do
      it 'respond with a 404 status code' do
        expect(response).to have_http_status(404)
      end

      it 'respond with a JSON with an error message' do
        expect(response.body).to eq('The comment does not exist!')
      end

      it 'does not delete any travel' do
        expect(Comment.count).to eq(@count)
      end
    end
  end

end