class Cart < ActiveRecord::Base

  def self.add_unique_item(session,product_id)
    puts "Cart has following items #{session[:cart_items]}"
    return false if session[:cart_items].include?(product_id)
    session[:cart_items] << product_id 
  end  
end
