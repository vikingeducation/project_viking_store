module CartsHelper
  def total
    total = 0
    return 0 if session[:cart].nil?
    session[:cart].each do |product_id, quantity|
      total += Product.find(product_id).price * quantity
    end
    total
  end
end
