module AddressesHelper

  def display_address(address)
    base = "#{address.city.name}, #{address.state.abbreviation} #{address.zip_code}"
    if address.secondary_address.blank?
      raw("#{address.street_address}<br>#{base}")
    else
      raw("#{address.street_address}<br>#{address.secondary_address}<br>#{base}")
    end
  end

  def user_address_index_buttons
    if params[:user_id]
      raw("#{ link_to 'New Address', new_admin_user_address_path(params[:user_id]), class: button_classes('success')}  #{link_to 'Back', admin_user_path(params[:user_id]), class: button_classes }")
    end
  end

  def user_orders_header
    if params[:user_id]
      user = User.find(params[:user_id])
      raw("<h2>for #{user.name} (##{user.id})<h2>")
    end
  end

end
