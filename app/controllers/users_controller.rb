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

  def search
    friend_ids = Rails.cache.fetch("user#{current_user.id}friends", expires_in: 13.seconds) do
      current_user.friends.pluck(:id) + [current_user.id]
    end

    if params[:username].present?
      @friends = User.where.not(id: friend_ids).where("UPPER(username) LIKE ?", "#{params[:username].upcase}%")
    else
      @friends = current_user.suggested_friends
    end

    respond_to do |format|
      format.js
    end
  end

  def friends
  end
end
