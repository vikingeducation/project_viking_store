module OrdersHelper
  def value(order)
    total = 0
    order.order_contents.each do |orderc|
      total+= orderc.product.price * orderc.quantity
    end
    total
  end
end
