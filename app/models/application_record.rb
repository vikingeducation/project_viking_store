class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

    def self.seven_days_users
      User.where('created_at > ?', (Time.zone.now.end_of_day - 7.days)).count
    end

    def self.seven_days_orders
      Order.where('created_at > ?', (Time.zone.now.end_of_day - 7.days)).count
    end

    def self.seven_days_products
      Product.where('created_at > ?', (Time.zone.now.end_of_day - 7.days)).count
    end

    def self.seven_days_revenue
      Order.find_by_sql("
          SELECT SUM(price * quantity) AS sum FROM orders
          JOIN order_contents ON orders.id = order_contents.order_id
          JOIN products ON products.id = order_contents.product_id
          WHERE checkout_date IS NOT NULL
          AND orders.created_at > '#{Time.now - 30.days}'
        ")
    end

    def self.month_users
      User.where('created_at > ?', (Time.zone.now.end_of_day - 30.days)).count
    end

    def self.month_orders
      Order.where('created_at > ?', (Time.zone.now.end_of_day - 30.days)).count
    end

    def self.month_products
      Product.where('created_at > ?', (Time.zone.now.end_of_day - 30.days)).count
    end

    def self.month_revenue
      Order.find_by_sql("
          SELECT SUM(price * quantity) AS sum FROM orders
          JOIN order_contents ON orders.id = order_contents.order_id
          JOIN products ON products.id = order_contents.product_id
          WHERE checkout_date IS NOT NULL
          AND orders.created_at > '#{Time.now - 30.days}'
        ")
    end

    def self.total_users
      User.count
    end

    def self.total_orders
      Order.count
    end

    def self.total_products
      Product.count
    end

    def self.total_revenue
      Order.find_by_sql("
          SELECT SUM(price * quantity) AS sum FROM orders
          JOIN order_contents ON orders.id = order_contents.order_id
          JOIN products ON products.id = order_contents.product_id
          WHERE checkout_date IS NOT NULL
        ")
    end

end
