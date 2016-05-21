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

require 'rails_helper'

RSpec.describe Friend, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
