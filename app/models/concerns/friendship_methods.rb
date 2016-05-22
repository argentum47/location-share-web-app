module FriendshipMethods
  extend ActiveSupport::Concern


  included do
    has_many :friendships, dependent: :destroy
    has_many :friends, through: :friendships

    has_many :reverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
    has_many :reverse_friends, through: :reverse_friendships, source: :user
  end


  def add_friend(user)
    friendships.create(friend_id: user.id)
  end

  def remove_friend(user)
    friendships.where(friend_id: user.id).destroy
  end

  def is_friend_of?(user_id)
    Friendship.where(user_id: id, friends: {friend_id: user_id}).present? || Friendship.where(user_id: user_id, friends: { friend_id: id }).present?
  end

  def viewable_locations(id)
    Location.joins(location_users: :shared_locations).where(shared_locations: { friend_id: id }) + locations.where(location_users: { is_public: true })
  end

  def all_friends
    results = []
    ActiveRecord::Base.connection.select_all(
      ActiveRecord::Base.send(:sanitize_sql_array, ["SELECT friend_id AS uid FROM friends WHERE user_id = ? UNION SELECT user_id AS uid FROM friends WHERE friend_id = ?", id, id])
    ).each { |u| results << u["uid"] }

    User.find(results)
  end
end
