module Admin::UsersHelper

  def full_address(address)
    address.street_address + ", " + address.city.name + ", " + address.state.name + ", " + address.zip_code.to_s
  end


end
