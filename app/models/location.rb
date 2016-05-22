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
  has_many :location_users, dependent: :destroy
  accepts_nested_attributes_for :location_users, reject_if: :all_blank

  geocoded_by :address, :latitude => :lat, :longitude => :lng
  after_validation :geocoded_by, unless: -> { lat.present? && lng.present? }

  def near(user, v=10)
    results = []
    nearbys(v).each do |loc|
      location = Location.find_by(lat: loc.lat, lng: loc.lng)

      unless location && user.location_users.exists?(location_id: location.id)
        results << loc
      end
    end

    results
  end
end
