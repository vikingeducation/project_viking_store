module AdminHelper
  def full_address(address)
    return "No address" if address.nil?
    addr = [address.street_address,
            address.secondary_address,
            address.city.name,
            address.state.name].select{ |x| !x.nil? }
    addr.join(", ")
  end
end
