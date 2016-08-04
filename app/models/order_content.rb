class OrderContent < ActiveRecord::Base

  class << self

    def highest_single_order_value
      OrderContent.select("users.first_name, (order_contents.quantity * products.price) AS order_value")
                  .joins("JOIN orders ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id JOIN users ON users.id = orders.user_id")
                  .where("orders.checkout_date IS NOT NULL")
                  .group("users.id, users.first_name, order_contents.quantity, products.price")
                  .order("order_value DESC")
                  .limit(1)
                  .first
                  .order_value
    end

    def highest_lifetime_value
      OrderContent
        .select("users.first_name, SUM(order_contents.quantity * products.price) AS highest_value")
        .joins("JOIN orders ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id JOIN users on users.id = orders.user_id")
        .where("orders.checkout_date IS NOT NULL")
        .group("users.id, users.first_name, order_contents.quantity, products.price")
        .order("highest_value DESC")
        .limit(1)
        .first
        .highest_value
    end

    def highest_average_value
      OrderContent
        .select("users.first_name, AVG(order_contents.quantity * products.price) AS average_value")
        .joins("JOIN orders ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id JOIN users on users.id = orders.user_id")
        .where("orders.checkout_date IS NOT NULL")
        .group("users.id, users.first_name, order_contents.quantity, products.price")
        .order("average_value DESC")
        .limit(1)
        .first
        .average_value
    end

    def most_orders_placed
      OrderContent
        .select("users.first_name, SUM(orders.id) AS most_orders_placed")
        .joins("JOIN orders ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id JOIN users on users.id = orders.user_id")
        .where("orders.checkout_date IS NOT NULL")
        .group("users.id, users.first_name, orders.id")
        .order("most_orders_placed DESC")
        .limit(1)
        .first
        .most_orders_placed
    end

  end

end
