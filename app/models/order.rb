class Order < ApplicationRecord

  def self.seven_days_orders
    where('created_at > ?', (Time.zone.now.end_of_day - 7.days)).count
  end

    def self.month_orders
      where('created_at > ?', (Time.zone.now.end_of_day - 30.days)).count
    end

    def self.total_orders
      count
    end

    def self.seven_days_revenue
      find_by_sql("
          SELECT SUM(price * quantity) AS sum FROM orders
          JOIN order_contents ON orders.id = order_contents.order_id
          JOIN products ON products.id = order_contents.product_id
          WHERE checkout_date IS NOT NULL
          AND orders.created_at > '#{Time.now - 30.days}'
        ")
    end

    def self.month_revenue
      find_by_sql("
          SELECT SUM(price * quantity) AS sum FROM orders
          JOIN order_contents ON orders.id = order_contents.order_id
          JOIN products ON products.id = order_contents.product_id
          WHERE checkout_date IS NOT NULL
          AND orders.created_at > '#{Time.now - 30.days}'
        ")
    end

    def self.total_revenue
      find_by_sql("
          SELECT SUM(price * quantity) AS sum FROM orders
          JOIN order_contents ON orders.id = order_contents.order_id
          JOIN products ON products.id = order_contents.product_id
          WHERE checkout_date IS NOT NULL
        ")
    end


end
