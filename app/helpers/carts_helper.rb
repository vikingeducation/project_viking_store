module CartsHelper

  def cart_total
    if @cart
      @cart.each do # |product_id, quantity|
        @total += Product.single_order_value
        # @total += Product.find(product_id).price * quantity
      end
    end
  end

end
