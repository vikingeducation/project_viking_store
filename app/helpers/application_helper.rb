module ApplicationHelper

  def full_address(address)
    if address
      "#{address.street_address}#{address.secondary_address}, #{address.city}, #{address.state} #{address.zip}"
    else
      "N/A"
    end
  end
end
