# == Schema Information
#
# Table name: friends
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  friend_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Friendship < ActiveRecord::Base
  self.table_name = "friends"

  belongs_to :user
  belongs_to :friend, class_name: "User"
end
