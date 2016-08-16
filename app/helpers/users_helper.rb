module UsersHelper
  def formatted_address(address)
    "#{address.street_address}, #{address.city.name}, #{address.state.name} #{address.zip_code}"
  end
end
