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

class Location < ActiveRecord::Base

  has_many :location_users
  accepts_nested_attributes_for :location_users

end
