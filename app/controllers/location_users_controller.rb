class LocationUsersController < ApplicationController
  before_action :authenticate_user!

  def destroy
    location_user = current_user.location_users.find_by(location_id: params[:id])

    if location_user && location_user.destroy
      redirect_to current_user
    end
  end

end
