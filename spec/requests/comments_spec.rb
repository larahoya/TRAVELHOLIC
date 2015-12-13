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

      it 'respond with an empty json' do
        data = JSON.parse(response.body)
        expect(data['comments'].length).to eq(0)
      end

    end
  end

  describe 'POST #create' do
    context 'all the attributes are correct' do
      before (:each) do
        @travel = FactoryGirl.create(:travel)
        @user = FactoryGirl.create(:user)
        @count = Comment.count
        post travel_comments_path(@travel), {:name => 'Lara', :description => 'This is a comment', :user_id => @user.id, :category => false} 
      end

      it 'respond with a 201 status code' do
        expect(response).to have_http_status(201)
      end

      it 'returns a json with the comment' do
        data = JSON.parse(response.body)
        expect(data['description']).to eq('This is a comment')
      end

      it 'creates a correct comment' do
        expect(Comment.last.description).to eq("This is a comment")
      end

      it 'creates a comment' do
        expect(Comment.count).to eq(@count + 1)
      end
    end

    context 'some attribute is missing or incorrect' do
      before (:each) do
        @travel = FactoryGirl.create(:travel)
        @user = FactoryGirl.create(:user)
        post travel_comments_path(@travel), {:name => 'Lara', :description => '', :user_id => @user.id, :category => false} 
      end

      it 'respond with a 404 status code' do
        expect(response).to have_http_status(404)
      end

      it 'respond with an error json' do
        data = JSON.parse(response.body)
        expect(data).to eq(["Description can't be blank"])
      end
    end
  end

  describe 'DESTROY #delete' do
    context 'the comment exists' do
      before (:each) do
        @travel = FactoryGirl.create(:travel)
        @user = FactoryGirl.create(:user)
        @comment = FactoryGirl.create(:comment, description: 'This is a comment',user_id: @user.id, travel_id: @travel.id)
        @count = Comment.count

        delete travel_comment_path(@travel, @comment)
      end
      it 'respond with a 204 status code' do
        expect(response).to have_http_status(204)
      end

      it 'delete the comment' do
        expect(Comment.count).to eq(@count-1)
      end
    end

    context 'the comment doesn´t exist' do
      before (:each) do
        @travel = FactoryGirl.create(:travel)
        @user = FactoryGirl.create(:user)
        @count = Comment.count
        
        delete travel_comment_path(@travel, 10)
      end

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