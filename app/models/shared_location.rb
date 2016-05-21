# == Schema Information
#
# Table name: shared_locations
#
#  id               :integer          not null, primary key
#  friend_id        :integer          not null
#  location_user_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class SharedLocation < ActiveRecord::Base
end
