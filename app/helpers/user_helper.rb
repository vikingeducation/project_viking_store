module UserHelper
  def print_address(id)
    a = Address.find(id)
    "#{a.street_address}, #{a.city.name}, #{a.state.name}"
  end

  def print_name(u)
    "#{u.first_name} #{u.last_name}"
  end

  def get_cart(u)
    u.orders.where("checkout_date IS NULL").count > 0
  end

  def is_checkout(o)
    if o.checkout_date
      !o.checkout_date.nil?
    end
  end

  def get_price_order(o)
    if is_checkout(o)
      current_order = Order.find_by_sql("SELECT SUM(p.price * oc.quantity) AS total
                         FROM orders JOIN order_contents oc 
                         ON orders.id = oc.order_id
                         JOIN products p ON oc.product_id = p.id
                         WHERE orders.id = #{o.id} 
                         GROUP BY orders.id")
      current_order.first.total
    end
  end

end
