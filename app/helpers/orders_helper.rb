module OrdersHelper

  def in_cart?(order)
   order.checkout_date.nil? ? true : false 
  end

end
