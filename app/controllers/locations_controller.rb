class LocationsController < ApplicationController
  before_action :authenticate_user!

  def create
    loc_par = location_params

    loc_par["location_users_attributes"].each do |k, v|
      loc_par["location_users_attributes"][k].merge!("user_id" => "#{current_user.id}")
    end

    @location = current_user.locations.new(loc_par)

    if @location.save
      redirect_to user_path(current_user)
    else
      render 'users#show'
    end
  end

  private

  def location_params
    params.require(:location).permit(:address, :street, :city, :postal_code, :country, :lat, :lng, location_users_attributes: [:is_public, :user_id])
  end
end
