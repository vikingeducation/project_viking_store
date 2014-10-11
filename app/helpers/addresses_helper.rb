module AddressesHelper
  def secondary_address(address)
    address.secondary_address ? ", #{address.secondary_address}" : ""
  end

  def name(user)
    "#{user.first_name} #{user.last_name}"
  end
end
