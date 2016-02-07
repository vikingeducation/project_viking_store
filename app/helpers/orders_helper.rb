module OrdersHelper

  def order_street_address(order)
    a = Address.find(order.shipping_id)
    a.street_address
  end

  def order_city(order)
    a = Address.find(order.shipping_id)
    a.city.name
  end

    def order_state(order)
    a = Address.find(order.shipping_id)
    a.state.name
  end



end
