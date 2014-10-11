module OrdersHelper

  def order_status(order)
    order.checked_out ? "PLACED" : content_tag(:span, "UNPLACED", class: "unplaced")
  end

  def order_date(order)
    order.checked_out ? order.checkout_date.strftime("%Y-%m-%d") : "N/A"
  end

  def order_address(order)
    order.shipping_address ? "#{order.shipping_address.street_address}": "N/A"
  end


  def shipping_city(order)
    order.shipping_address ? order.shipping_address.city.name : "N/A"
  end

  def shipping_state(order)
    order.shipping_address ? order.shipping_address.state.name : "N/A"
  end

  def name(user)
    "#{address.user.first_name} #{address.user.last_name}"
  end
end
