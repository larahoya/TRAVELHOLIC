class CommentsController < ApplicationController

  def index
    travel = Travel.find_by(id: params[:travel_id])
    @comments = travel.comments
    if @comments.count == 0
      render status: 404, json: 'The travel doesn´t have any comment!'
    end
  end

  def create
  end

  def destroy
  end

end
