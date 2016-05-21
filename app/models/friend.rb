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

class Friend < ActiveRecord::Base
  #has_and_belongs_to_many :location_users
end
