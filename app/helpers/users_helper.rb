module UsersHelper
  def display_address(user, type = "billing")
    symbol = ("default_" + type + "_address").to_sym
    if user.respond_to?(symbol) && user.send(symbol)
      address = user.send(symbol)
      address.full_address
    else
      "There is no #{type} address for this user."
    end
  end

  def address_id(address, index)
    if address.persisted?
      address.id
    else
      Address.last.id + index + 1
    end
  end

  def is_default_billing?(user, address)
    user.billing_id == address
  end

  def is_default_shipping?(user, address)
    user.shipping_id == address
  end

  def generate_shipping_button(user, user_address, index)
    address = address_id(user_address, index)
    return radio_button_tag("user[shipping_id]",
                            address,
                            checked = is_default_shipping?(user, address))
  end

  def generate_billing_button(user, user_address, index)
    address = address_id(user_address, index)
    return radio_button_tag("user[billing_id]",
                            address,
                            checked = is_default_billing?(user, address))
  end

end
