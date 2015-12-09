class UsersController < ApplicationController

  def show
    @user = User.find_by(id: params[:id])
    if !@user
      render status: 404, json: 'User not found'
    end
  end

end
