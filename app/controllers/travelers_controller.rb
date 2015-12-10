class TravelersController < ApplicationController

  def index
    user = User.find_by(id: params[:user_id])
    @travelers = user.travelers
    if @travelers.count == 0
      render status: 404, json: 'The user doesn´t have any traveler!'
    end
  end

  def show
    traveler = Traveler.find_by(id: params[:id])
    if traveler
      render status: 200, json: traveler
    else
      render status: 404, json: 'The traveler does not exist!'
    end
  end

  def create
    user = User.find_by(id: params[:user_id])
    traveler = user.travelers.new
    traveler.set_params(params)

    if traveler.save
      render status: 201, json: traveler
    else
      errors = traveler.errors.full_messages
      render status: 404, json: errors
    end

  end

  def destroy
    traveler = Traveler.find_by(id: params[:id])
    if traveler && traveler.destroy
      render status: 204, json: :no_content
    else
      render status: 404, json: 'The traveler does not exist!'
    end
  end

  def update
    traveler = Traveler.find_by(id: params[:id])
    traveler.set_params(params)

    if traveler && traveler.save
      render status: 201, json: traveler
    else
      render status: 404, json: 'The traveler couldn´t be updated!'
    end

  end

end
