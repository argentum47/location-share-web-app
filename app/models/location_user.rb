# == Schema Information
#
# Table name: location_users
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  location_id :integer          not null
#  is_public   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class LocationUser < ActiveRecord::Base
  belongs_to :user, inverse_of: :location_users
  belongs_to :location, inverse_of: :location_users

  has_many :shared_locations
end
