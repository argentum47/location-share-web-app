# == Schema Information
#
# Table name: locations
#
#  id          :integer          not null, primary key
#  street      :string(255)
#  city        :string(255)
#  postal_code :string(255)
#  lat         :decimal(15, 10)
#  lng         :decimal(15, 10)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  country     :string(255)
#  address     :string(255)      not null
#

require 'rails_helper'

RSpec.describe Location, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
