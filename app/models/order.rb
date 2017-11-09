class Order < ApplicationRecord
  extend Dateable

  class << self
    def checkout_from(date)
      from(date, "checkout_date")
    end

    def total_revenue(&block)
      joined_products.where.
        not(orders: {checkout_date: nil}).
        sum("products.price")
    end

    private

    def joined_products
      joins("INNER JOIN order_contents ON orders.id = order_contents.order_id").
      joins("INNER JOIN products ON order_contents.product_id = products.id")
    end
  end
end
