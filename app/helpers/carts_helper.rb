module CartsHelper
  def total
    total = 0
    session[:cart].each do |product_id, quantity|
      total += Product.find(product_id).price * quantity
    end
    total
  end
end
