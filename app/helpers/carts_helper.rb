module CartsHelper
  def order_value(order)
    order.reduce(0) do |acc, o|
      acc += Product.find(o["product_id"].to_i).price * o["quantity"].to_i
    end
  end
end
