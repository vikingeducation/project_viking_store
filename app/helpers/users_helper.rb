module UsersHelper

  def address(add)
    base = "#{add.city.name}, #{add.state.name} #{add.zip_code}"
    if add.secondary_address.blank?
      "#{add.street_address}, " + base
    else
      "#{add.street_address}, #{add.secondary_address}," + base
    end
  end
end
