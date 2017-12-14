module UsersHelper

  def address_or_create(user, address_id)
    address = Address.find_by(id: address_id)
    if address == nil
      link_to 'Create Address', new_admin_user_address_path(user)
    else
      display_address(address)
    end
  end

end
