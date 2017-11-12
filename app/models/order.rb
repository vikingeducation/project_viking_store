class Order < ApplicationRecord
  extend Dateable

  class << self
    def checkout_from(date)
      from(date, "checkout_date")
    end

    def total_revenue
      with_products.where.
        not(orders: {checkout_date: nil}).
        sum("products.price")
    end

    def with_products
      joins("INNER JOIN order_contents ON orders.id = order_contents.order_id").
      joins("INNER JOIN products ON order_contents.product_id = products.id")
    end

    def with_products_and_users
      with_products.joins("INNER JOIN users ON orders.user_id = users.id")
    end
  end
end
