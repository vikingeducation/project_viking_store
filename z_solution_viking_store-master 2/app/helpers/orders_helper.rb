module OrdersHelper

  def order_status(order)
    order.checkout_date ? "PLACED" : content_tag(:span, "UNPLACED", class: "unplaced")
  end

  def order_date(order)
    order.checkout_date && order.id ? order.checkout_date.strftime("%Y-%m-%d") : "N/A"
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

  def credit_card(user)
    if user.credit_cards.first
      user.credit_cards.first.card_number
    else
      "N/A"
    end
  end

  def delete_credit_card(credit_card)
    if credit_card.persisted?
      link_to "Delete Card", credit_card_path(credit_card.id), method: 'delete'
    end
  end

  def index_order_create(user)
    if user
      (link_to "Create Order for #{user.name}", new_admin_user_order_path(user), :class => "btn btn-block btn-default btn-lg btn-primary")
    else
      raw("<em>Create new orders from within #{(link_to 'User', admin_users_path)} profiles </em>")
    end
  end

  def order_title(order)
    order.checked_out? ? "Order #{order.id}" : "#{order.user.name}'s Cart"
  end

end
