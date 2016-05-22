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
  has_many :locations, -> { uniq }, through: :location_users

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  has_many :reverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :reverse_friends, through: :reverse_friendships, source: :user

  before_save :set_username_if_empty

  def all_friends
    results = []
    ActiveRecord::Base.connection.select_all(
      ActiveRecord::Base.send(:sanitize_sql_array, ["SELECT friend_id AS uid FROM friends WHERE user_id = ? UNION SELECT user_id AS uid FROM friends WHERE friend_id = ?", id, id])
    ).each { |u| results << u["uid"] }

    User.find(results)
  end

  def add_friend(user)
    friendships.create(friend_id: user.id)
  end

  def remove_friend(user)
    friendships.where(friend_id: user.id).destroy
  end

  def is_friend_of?(user_id)
    Friendship.where(user_id: id, friends: {friend_id: user_id}).present? ||
      Friendship.where(user_id: user_id, friends: { friend_id: id }).present?

  end

  def viewable_locations(id)
    Location.joins(location_users: :shared_locations).where(shared_locations: { friend_id: id }) + locations.where(location_users: { is_public: true })
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
