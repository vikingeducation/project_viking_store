module AddressesHelper
  def address_owner
    if @user
      content_tag(:h3, "#{@user.name}'s Addresses")
    else
      content_tag(:h3, "Addresses")
    end
  end

  def button_for_new_address
    if @user
      link_to "Create a new address for #{@user.name}!",
              new_admin_address_path(user_id: @user.id),
              class: "btn btn-primary"
    end
  end
end
