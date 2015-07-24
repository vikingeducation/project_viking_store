class User < ActiveRecord::Base
  has_many :address

  # 1. Overall Platform

  # Last 7 Days

  def user_count(timeframe = nil)

    if timeframe.nil?
      return User.all.length
    else
      return User.where("created_at > ?", timeframe.days.ago).count
    end
  end

  def top_user_location(scope, num=3)
    # Finds top user 
    if scope == 'state'
      User.select("COUNT(*) AS num_of_users, states.name")
          .joins("JOIN addresses ON users.billing_id=addresses.id")
          .joins("JOIN states ON addresses.state_id=states.id")
          .group("states.name")
          .order("num_of_users DESC")
          .limit(num)
    else
      User.select("COUNT(*) AS num_of_users, cities.name")
          .joins("JOIN addresses ON users.billing_id=addresses.id")
          .joins("JOIN cities ON addresses.city_id=cities.id")
          .group("cities.name")
          .order("num_of_users DESC")
          .limit(num)
    end
  end

  def highest_value(scope = "single")
    # Finds highest revenue from individual user
    # Returns highest order if "single", returns total revenue from user if "total"
    # Returns highest average order value for user if "average"
    if scope == 'single'
      User.select("ROUND(SUM(quantity * products.price), 2) AS total, COUNT(*), orders.id AS order_num, users.id AS user_num, users.first_name, users.last_name")
          .joins("JOIN orders ON orders.user_id=users.id")
          .joins("JOIN order_contents ON order_contents.order_id=orders.id")
          .joins("JOIN products ON order_contents.product_id=products.id")
          .where("checkout_date IS NOT NULL")
          .group("users.id, orders.id")
          .order("total DESC")
          .limit(10)
    elsif scope == 'total'
      User.select("ROUND(SUM(quantity * products.price), 2) AS total, orders.id AS order_num, users.id AS user_num, users.first_name, users.last_name")
          .joins("JOIN orders ON orders.user_id=users.id")
          .joins("JOIN order_contents ON order_contents.order_id=orders.id")
          .joins("JOIN products ON order_contents.product_id=products.id")
          .where("checkout_date IS NOT NULL")
          .group("users.id")
          .order("total DESC")
          .flimit(10)
    elsif scope == 'average'
      User.select("ROUND(SUM(quantity * products.price) / COUNT(orders.id), 2) AS average, COUNT(orders.id) AS order_num, users.id AS user_num, users.first_name, users.last_name")
          .joins("JOIN orders ON orders.user_id=users.id")
          .joins("JOIN order_contents ON order_contents.order_id=orders.id")
          .joins("JOIN products ON order_contents.product_id=products.id")
          .where("checkout_date IS NOT NULL")
          .group("users.id")
          .order("average DESC")
          .limit(10)
    else
      raise ArgumentError.new("Invalid Input")
    end
  end

end
