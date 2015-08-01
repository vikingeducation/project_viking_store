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

  def is_default_billing?(user, address_id)
    user.billing_id == address_id
  end

  def is_default_shipping?(user, address_id)
    user.shipping_id == address_id
  end


  # If the user is persisted, we just make a radio button with the value of
  # the address' id.
  # If the user ISN'T persisted, we have to do a hacky work around
  # in which we save the address given and set it to the user's default
  # in the create method of the users controller.
  def generate_shipping_button(user, user_address, index)
    if user.persisted?
      return radio_button_tag("user[shipping_id]",
                              user_address.id,
                              checked = is_default_shipping?(user, user_address.id))
    else
      return radio_button_tag("shipping_address", index)
    end
  end

  def generate_billing_button(user, user_address, index)
    if user.persisted?
      return radio_button_tag("user[billing_id]",
                              user_address.id,
                              checked = is_default_billing?(user, user_address.id))
    else
      return radio_button_tag("billing_address", index)
    end
  end

end
