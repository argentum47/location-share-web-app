class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @location = current_user.locations.build
    @locations = if current_user.id == params[:id]
                   current_user.locations
                 else
                   current_user.viewable_locations(params[:id])
                 end
  end
end
