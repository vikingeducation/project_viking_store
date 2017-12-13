module UsersHelper

  def address(user, address_id)
    add = Address.find_by(id: address_id)
    if add == nil
      link_to 'Create Address', new_admin_user_address_path(@user)
    else
      base = "#{add.city.name}, #{add.state.name} #{add.zip_code}"
      if add.secondary_address.blank?
        "#{add.street_address}, " + base
      else
        "#{add.street_address}, #{add.secondary_address}," + base
      end
    end
  end

end
