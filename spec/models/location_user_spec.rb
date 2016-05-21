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

require 'rails_helper'

RSpec.describe LocationUser, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
