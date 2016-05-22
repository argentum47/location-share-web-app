class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @locations = if current_user.id == @user.id
                   current_user.locations
                 else
                   @user.viewable_locations(current_user.id)
                 end
  end
end
