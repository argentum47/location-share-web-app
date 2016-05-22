module FriendSuggestions
  extend ActiveSupport::Concern

  def suggested_friends
    results = [];
    _friends = friends.present? ? friends : []

    # add some mutual friends

    _friends.each do |f|
      results << f.friends.where.not(friends: { friend_id: id })
    end

    results = results.flatten

    # add some random active people
    results << User.includes(:friends).where.not(id: [results.map(&:id), _friends.map(&:id)].flatten).order("friends.updated_at desc").uniq.take(10)
    results.flatten
  end
end
