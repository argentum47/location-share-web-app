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

require 'rails_helper'

RSpec.describe SharedLocation, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
