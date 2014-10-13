module UsersHelper
  def completed_orders(user)
    user.orders.where(checked_out: true)
  end

  def address_maker(addr)
		"#{addr.street_address}, #{addr.city.name}, #{addr.state.name}, #{addr.zip_code}"
  end

  def order_value(order)
    number_to_currency((order.purchases.map { |purchase| purchase.quantity * purchase.product.price }).inject(:+))
  end

  def cart_link(user)
    user.orders.all? { |o| o.checked_out} ? "Unplaced Order" : (link_to "Unplaced Order", user_order_path(user.id, user.orders.where(checked_out: false).first.id))
  end
end
