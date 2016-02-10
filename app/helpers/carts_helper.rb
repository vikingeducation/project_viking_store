module CartsHelper

  def cart_total
    if @cart
      @cart.each do |product_id, quantity|
        @total += Product.find(product_id).price * quantity
      end
    end
    @total
  end

  def find_product(product_id)
    Product.find(product_id.to_i)
  end


end
