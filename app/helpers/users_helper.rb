module UsersHelper

  def default_city(user)
    address = user.default_shipping
    if address.nil?
      "n/a"
    else
      address.city.name
    end
  end

  def default_state(user)
    address = user.default_shipping
    if address.nil?
      "n/a"
    else
      address.state.name
    end
  end

  def order_value(order)
    order.products.sum("quantity*price")
  end

  def status(order)
    if order.checkout_date.nil?
      "NOT PLACED"
    else
      "PLACED"
    end
  end

  def full_name(user)
    "#{user.first_name} #{user.last_name}"
  end

  def number_orders(user)
    user.orders.where('checkout_date IS NOT NULL').count || "n/a"
  end

  def last_order_date(user)
    orders = user.orders.select('checkout_date').where('checkout_date IS NOT NULL')
    unless orders.empty?
      orders.order('checkout_date DESC').limit(1)[0].checkout_date.strftime("%m/%d/%Y")
    else
     "n/a"
   end
  end
end
