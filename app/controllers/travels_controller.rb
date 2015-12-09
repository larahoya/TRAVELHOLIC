class TravelsController < ApplicationController

  def show
    @travel = Travel.find_by(id: params[:id])
    if @travel == nil
      render status: 404, json: 'The travel does not exist!'
    end
  end

  def create
    travel = Travel.new
    travel.set_params(params)

    if travel.save
      render status: 201, json: travel
    else
      errors = travel.errors.full_messages
      render status: 404, json: errors
    end
  end

  def destroy
    travel = Travel.find_by(id: params[:id])
    if travel && travel.destroy
      render status: 204, json: :no_content
    else
      render status: 404, json: 'The travel does not exist!'
    end
  end

  def update
    @travel = Travel.find_by(id: params[:id])
    @travel.set_params(params)

    if !@travel || !@travel.save
      render status: 404, json: 'The travel couldn´t be updated!'
    end

  end

end
