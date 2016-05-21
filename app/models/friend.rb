# == Schema Information
#
# Table name: friends
#
#  id          :integer          not null, primary key
#  follower_id :integer          not null
#  followed_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class FriendShip < ActiveRecord::Base
  self.table_name = "friends"

  belongs_to :user
  belongs_to :friend, class_name: "User"
end
