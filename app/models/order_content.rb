class OrderContent < ActiveRecord::Base

  class << self

    def highest_single_order_value
      OrderContent.select("users.first_name, (order_contents.quantity * products.price) AS order_value")
                  .joins("JOIN orders ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = product_id JOIN users ON users.id = orders.user_id")
                  .where("orders.checkout_date IS NOT NULL")
                  .group("users.id, users.first_name, order_contents.quantity, products.price")
                  .order("order_value DESC")
                  .limit(1)
                  .first
                  .order_value
    end

    def highest_lifetime_value
      
    end

  end

end
