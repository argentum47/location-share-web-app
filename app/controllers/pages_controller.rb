class PagesController < ApplicationController
  def show
    if current_user
      @users = User.where.not(id: current_user.id).limit(5)
    end
  end
end
