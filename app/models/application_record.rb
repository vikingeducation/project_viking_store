class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

    def self.seven_days_users
      User.where('created_at > ?', (Time.zone.now.end_of_day - 7.days)).count
    end

    def self.total_users
      User.count
    end

    def self.total_orders
      Orders.where('checkout_date != ?', nil ).count
    end

    def self.total_products
      Products.count
    end

    def self.total_revenue
      User.find_by_sql("
          SELECT 
        ")
    end


end
