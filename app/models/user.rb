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

  has_many :location_users, dependent: :destroy
  has_many :locations, through: :location_users

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :reverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :reverse_friends, through: :reverse_friendships, source: :user

  before_save :set_username_if_empty

  def viewable_locations(id)
    locations.where(location_users: { is_public: true })
  end

  def friends
    User.joins(:friendships).where("friends.followed_id = :uid OR friends.follower_id = :uid", id)
  end

  def add_friend(user)
    friendships.create(friend_id: user.id)
  end

  def remove_friend(user)
    friendships.where(friend_id: user.id).destroy
  end

  def is_friend_of?(user_id = self.id)
    Friend.where("follower_id = :uid OR followed_id = :uid", { uid: user_id }).present?
  end

  private

  def set_username_if_empty
    unless username.present?
      self.username = email.split("@").first
    end
  end

end
