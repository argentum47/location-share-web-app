class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @locations = current_user.viewable_locations(params[:id])
    @location = current_user.locations.build
  end
end
