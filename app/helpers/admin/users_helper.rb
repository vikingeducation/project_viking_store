module Admin::UsersHelper
  def render_address(addr)
    if addr
      "#{addr.street_address}, #{addr.city.name}, #{addr.state.name}"
    else
      "None"
    end
  end
end
