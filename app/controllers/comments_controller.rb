class CommentsController < ApplicationController

  def index
    travel = Travel.find_by(id: params[:travel_id])
    @comments = travel.comments if travel
  end

  def create
    comment = Comment.new(travel_id: params[:travel_id], description: params[:description], user_id: params[:user_id], category: params[:category], name: params[:name])
    
    if comment.save
      render status: 201, json: comment
    else
      errors = comment.errors.full_messages
      render status: 404, json: errors
    end

  end

  def destroy
    comment = Comment.find_by(id: params[:id])
    if comment && comment.destroy
      render status: 204, json: :no_content
    else
      render status: 404, json: 'The comment does not exist!'
    end
  end

end
