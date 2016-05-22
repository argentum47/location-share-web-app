module LocationsHelper
  def get_address_for(location)
    if location.address.present?
      location.address
    elsif(location.city.present? || location.country.present?)
      [location.street, location.city, location.postal_code].compact.join(" ") + (location.country || "")
    else
      first_result = Geocoder.search("#{location.lat},#{location.lng}").first
      if first_result.present?
        first_result.address
      else
        "#{location.lat.round(3)} #{location.lng.round(3)}"
      end
    end
  end

  def get_selected_users(location_user)
    location_user.shared_locations.pluck(:friend_id)
  end
end
