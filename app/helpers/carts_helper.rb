module CartsHelper

  def find_order_contents(product_id)
    @order_contents.find_by(product_id: product_id)
  end

  def order_quantity(product_id)
    find_order_contents(product_id).quantity
  end

  def remove_product(product_id)
    find_order_contents(product_id).destroy
  end

end
