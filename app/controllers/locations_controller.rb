class LocationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @location = Location.find_by(lat: location_params["lat"], lng: location_params["lng"])

    if !@location
      @location = Location.create(location_params)
    end

    if @location && @location.valid?
      if @location.location_users.create(is_public: params["is_public"], user_id: current_user.id)

        unless params["is_public"].present? && !params["shared_users"].present?
          current_user.share_locations(@location, params["shared_users"])
        end

        redirect_to current_user

      else
        flash[:error] = "Something went wrong, Try again"
        redirect_to current_user
      end
    else
      render 'users#show'
    end
  end

  def show
    location = Location.find(params[:id])
    @locations = location.near(current_user, params[:distance] || 10)
  end

  def edit
    @location_user = current_user.location_users.find_by(location_id: params[:id])
    @location = current_user.locations.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    location_user = current_user.location_users.find_by(location_id: @location.id)

    unless Location.find_by(lat: location_params["lat"], lng:  location_params["lng"])
      @location = Location.create(location_params)
    end

    if location_user && @location.valid?
      if location_user.update(location_id: @location.id, is_public: params["is_public"].nil? ? "0" : "1")
        unless params["is_public"] && !params["shared_users"].present?
          current_user.share_locations(@location, params["shared_users"])
        else
          if params["is_public"]
            current_user.make_public(@location)
          end
        end

        redirect_to current_user

      else
        flash[:error] = "Something went wrong, Try again"
        redirect_to current_user
      end
    else
      render :edit
    end
  end

  private

  def location_params
    params.require(:location).permit(:address, :street, :city, :postal_code, :country, :lat, :lng)
  end
end
