module UsersHelper

  def last_order_date(user)
    if user.orders.where.not(:checkout_date => nil).present?
      user.orders.where.not(:checkout_date => nil).
                        order(:checkout_date).last.
                        checkout_date.strftime("%Y-%m-%d")
    else
      "N/A"
    end
  end

  def order_date(order)
    order.checkout_date && order.id ? order.checkout_date.strftime("%Y-%m-%d") : "N/A"
  end

  def billing_address(user)
    if user.billing_address
      "#{user.billing_address.street_address}#{secondary_address(user.billing_address)}, #{billing_city(user)}, #{billing_state(user)}"
    else
      "N/A"
    end
  end

  def shipping_address(user)
    if user.shipping_address
      "#{user.shipping_address.street_address}#{secondary_address(user.shipping_address)}, #{user.shipping_address.city.name}, #{user.shipping_address.state.name}"
    else
      "N/A"
    end
  end

  def secondary_address(address)
    address.secondary_address ? ", #{address.secondary_address}" : ""
  end

  def billing_city(user)
    user.billing_address ? user.billing_address.city.name : "N/A"
  end

  def billing_state(user)
    user.billing_address ? user.billing_address.state.name : "N/A"
  end


  def name(user)
    "#{user.first_name} #{user.last_name}"
  end

  def cart(user)
    if has_cart?(user)
      user.orders.find_by(:checkout_date => nil)
    else
      nil
    end
  end

  def status(order)
    order.checkout_date ? "PLACED" : content_tag(:span, "UNPLACED", class: "unplaced")
  end

  def cart_link(user)
    user.orders.all? { |o| o.checked_out? } ? "Unplaced Order" : (link_to "Unplaced Order", admin_user_order_path(user.id, user.orders.where(checkout_date: nil).first.id))
  end

  private

  def has_cart?(user)
    user.orders.where(:checkout_date => nil).count == 1
  end

end
