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
    travel = Travel.new
    travel.title = params['title']
    travel.initial_date = params['initial_date']
    travel.final_date = params['final_date']
    travel.description = params['description']
    travel.budget = (params['budget'] || 'medium')
    travel.set_maximum_people(params['maximum_people'])
    travel.people = 1

    travel.add_tags(params['tags'])
    travel.add_requirements(params['requirements'])
    travel.add_countries(params['countries'])
    travel.add_places(params['places'])

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
      render status: 200, json: 'The travel was deleted succesfully!'
    else
      render status: 404, json: 'The travel does not exist!'
    end
  end

  def update
    travel = Travel.find_by(id: params[:id])
    if travel && travel.update(travel_params)
      render status: 200, json: 'The travel was updated succesfully!'
    else
      render status: 404, json: 'The travel couldn´t be updated!'
    end
  end

  private

  def travel_params
    params.require(:travel).permit(:title, :initial_date, :final_date, :description, :budget, :maximum_people)
  end

end