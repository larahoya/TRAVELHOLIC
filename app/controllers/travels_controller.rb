class TravelsController < ApplicationController

  def index
    user = User.find_by(id: params[:user_id])
    @travels = user.travels
    if @travels.count == 0
      render status: 404, json: 'The user doesn´t have any travel!'
    end
  end

  def show
    @travel = Travel.find_by(id: params[:id])
    if @travel == nil
      render status: 404, json: 'The travel does not exist!'
    end
  end

  def create
    user = User.find_by(id: params[:user_id])
    travel = user.travels.new(travel_params)

    travel.set_tags(params)
    travel.set_image
    travel.people = 1
    travel.travelers << user.travelers.first

    if travel.save
      render status: 201, json: travel
    else
      errors = travel.errors.full_messages
      render status: 404, json: errors
    end
  end

  def destroy
    travel = Travel.find_by(id: params[:id])
    Participation.where('travel_id = ?', travel.id).destroy_all if travel
    if travel && travel.destroy
      render status: 204, json: :no_content
    else
      render status: 404, json: 'The travel does not exist!'
    end
  end

  def update
    @travel = Travel.find_by(id: params[:id])
    @travel.update(travel_params)

    @travel.set_tags(params)

    if !@travel || !@travel.save
      render status: 404, json: 'The travel couldn´t be updated!'
    end
  end

# Methods to join or left a travel

  def join
    @travel = Travel.find_by(id: params[:travel_id])
    @traveler = Traveler.find_by(id: params[:id])
    validation = @travel.check_requirements(@traveler) if @travel
    already_included = @travel.travelers.include?(@traveler) if @travel
    if @travel && validation && !already_included
      @travel.travelers << @traveler
      @travel.update_people
      render status: 200, json: :no_content
    else
      render status: 404, json: :no_content
    end
  end

  def left
    @travel = Travel.find_by(id: params[:travel_id])
    @traveler = Traveler.find_by(id: params[:id])
    if @travel && @travel.travelers.include?(@traveler)
      @travel.travelers.delete(@traveler)
      @travel.update_people
      render status: 200, json: :no_content
    else
      render status: 404, json: :no_content
    end
  end

# Method to search

  def search
    @travels = Travel.filter(params, Travel.all)
    if @travels.length == 0
      render status: 404, json: :no_content
    end
  end

  private

  def travel_params
    params.require(:travel).permit(:title, :initial_date, :final_date, :description, :budget, :maximum_people)
  end


end
