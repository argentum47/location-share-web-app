# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string(255)      not null
#

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :confirmable

  include FriendshipMethods
  include FriendSuggestions

  has_many :location_users, dependent: :destroy
  has_many :locations, -> { uniq }, through: :location_users

  before_save :set_username_if_empty

  def favourite_locations
    locations.order("locations.created_at DESC").take(5)
  end

  def share_locations(location, user_ids)
    # could be done with some background job in batches
    # or maybe used redis to share location instead of mysql and lock the database

    location_user = location_users.find_by(location_id: location.id)
    user_ids.each do |i|
      if User.exists?(i)
        SharedLocation.find_or_create_by(friend_id: i, location_user_id: location_user.id)
      end
    end
  end

  def make_public(location)
    location_user = location_users.find_by(location_id: location.id, user_id: id)

    if location_user.present?
      SharedLocation.destroy_all(location_user_id: location_user.id)
    end
  end

  def to_param
    [id, username].join("-")
  end

  private

  def set_username_if_empty
    unless username.present?
      self.username = email.split("@").first
    end
  end

end
