module ProductsHelper

  def product_quantity(order, product)
    OrderContent.where(:order_id => order.id).where(:product_id => product.id).first.quantity
  end
end
