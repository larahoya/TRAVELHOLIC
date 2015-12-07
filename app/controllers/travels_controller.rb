class TravelsController < ApplicationController

  def show
    travel = Travel.find_by(id: params[:id])
    if travel != nil
      render status: 200, json: travel
    else
      render status: 404, json: 'The travel does not exist!'
    end
  end

  def create
  end

end
