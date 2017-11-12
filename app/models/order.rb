class Order < ApplicationRecord
  extend Dateable

  class << self
    def checkout_from(date)
      from(date, "checkout_date")
    end

    def total_revenue
      joined_products.where.
        not(orders: {checkout_date: nil}).
        sum("products.price")
    end

    # def highest_order
    #   joined_products.
    #     select("concat(users.first_name, ' ', users.last_name) AS customer_name, SUM(products.price) AS total").
    #     joins("INNER JOIN users ON orders.user_id = users.id").
    #     group("customer_name").order("total DESC").limit(1).first
    # end
    #
    # private

    def joined_products
      joins("INNER JOIN order_contents ON orders.id = order_contents.order_id").
      joins("INNER JOIN products ON order_contents.product_id = products.id")
    end
  end
end
