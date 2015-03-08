module UsersHelper
  def billing_address_for user
    address = user.billing_address
    "#{address.street_address}, #{address.city.name}, #{address.state.name} #{address.zip_code}"
  end

  def shipping_address_for user
    address = user.shipping_address
    "#{address.street_address}, #{address.city.name}, #{address.state.name} #{address.zip_code}"
  end
end
