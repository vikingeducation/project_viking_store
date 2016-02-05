module UsersHelper

  def full_billing(user)
    if user.default_billing_address
      "#{user.default_billing_address.street_address}#{user.default_billing_address.secondary_address}, #{user.default_billing_address.city.name}, #{user.default_billing_address.state.name}"
    else
      "N/A"
    end
  end      


  def full_shipping(user)
    if user.default_shipping_address
      "#{user.default_shipping_address.street_address}#{user.default_shipping_address.secondary_address}, #{user.default_shipping_address.city.name}, #{user.default_shipping_address.state.name}"
    else
      "N/A"
    end
  end


  def all_addresses(user)
    dropdown = []
    if user.addresses
      user.addresses.each do |address|
       dropdown << "#{address.street_address}#{address.secondary_address}, #{address.city.name}, #{address.state.name}"
      end
    end
    dropdown   
  end


end
