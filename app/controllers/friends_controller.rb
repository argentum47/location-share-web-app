class FriendsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:friend_id])
    current_user.add_friend(user)
    redirect_to user
  end

  def destory
    user = User.find(follower_id: params[:id])
    current_user.remove_friend(user)
    redirect_to user
  end
end
