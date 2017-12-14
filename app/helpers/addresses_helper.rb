module AddressesHelper

  def display_address(address)
    base = "#{address.city.name}, #{address.state.abbreviation} #{address.zip_code}"
    if address.secondary_address.blank?
      raw("#{address.street_address}<br>#{base}")
    else
      raw("#{address.street_address}<br>#{address.secondary_address}<br>#{base}")
    end
  end

end
