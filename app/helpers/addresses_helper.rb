module AddressesHelper
  def secondary_address(address)
    address.secondary_address ? ", #{address.secondary_address}" : ""
  end

  def name(user)
    "#{address.user.first_name} #{address.user.last_name}"
  end
end
