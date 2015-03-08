module UsersHelper
  def billing_address_for user
    address = user.billing_address
    if address.nil?
      "NONE SELECTED"
    else
      "#{address.street_address}, #{address.city.name}, #{address.state.name} #{address.zip_code}"
    end
  end

  def shipping_address_for user
    address = user.shipping_address
    if address.nil?
      "NONE SELECTED"
    else
      "#{address.street_address}, #{address.city.name}, #{address.state.name} #{address.zip_code}"
    end
  end
end
