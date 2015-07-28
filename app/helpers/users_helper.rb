module UsersHelper
  def display_address(user, type = "billing")
    symbol = ("default_" + type + "_address").to_sym
    if user.respond_to?(symbol) && user.send(symbol)
      address = user.send(symbol)
      address.street_address + ", " + address.city.name + ", " + address.state.name
    else
      "There is no #{type} address for this user."
    end
  end
end
