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
    # travel = Travel.new
    # travel.title = params['title']
    # travel.initial_date = params['initial_date']
    # travel.final_date = params['final_date']
    # travel.description = params['description']
    # travel.budget = params['budget']
    # travel.maximum_people = params['maximum_people']
    # travel.people = 1
    # binding.pry
  end

end
