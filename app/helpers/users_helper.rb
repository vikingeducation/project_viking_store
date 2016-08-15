module UsersHelper
  def order_value(order)
    value = 0
    order.order_contents.each do |line|
      value += line.quantity*line.product.price
    end
    value
  end
end
