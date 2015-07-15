class User < ActiveRecord::Base

  def self.count_new_users(day_range = nil)
    if day_range.nil?
      User.all.count
    else
      User.where("created_at > ?", Time.now - day_range.days).count
    end
  end


  def self.top_3_by_state
    User.joins("JOIN addresses ON users.billing_id = addresses.id
                JOIN states ON addresses.state_id = states.id").
          group("states.name").
          order("count(distinct users.id) DESC").limit(3).
          count(:id)
  end


  def self.top_3_by_city
    User.joins("JOIN addresses ON users.billing_id = addresses.id
                JOIN cities ON addresses.city_id = cities.id").
          group("cities.name").
          order("count(distinct users.id) DESC").limit(3).
          count(:id)
  end


  def self.top_users
    { 'Highest Single Order Value' => self.biggest_order,
      'Highest Lifetime Value' => self.highest_lifetime_orders,
      'Highest Average Order Value' => self.highest_average_order,
      'Most Orders Placed' => self.most_orders
    }
  end


  private


=begin
  def self.get_order_values
    User.select("users.*, orders.id AS order_id, SUM(products.price * order_contents.quantity) AS order_value").
          joins("JOIN orders ON users.id = orders.user_id
                 JOIN order_contents ON orders.id = order_contents.order_id
                 JOIN products ON order_contents.product_id = products.id").
          where("orders.checkout_date IS NOT NULL").
          group("users.id, orders.id")
  end
=end


  def self.biggest_order
    result = User.select("users.*, orders.id AS order_id, SUM(products.price * order_contents.quantity) AS order_value").
                  joins("JOIN orders ON users.id = orders.user_id
                         JOIN order_contents ON orders.id = order_contents.order_id
                         JOIN products ON order_contents.product_id = products.id").
                  where("orders.checkout_date IS NOT NULL").
                  group("users.id, orders.id").
                  order('order_value DESC').
                  first

    [result.first_name, result.last_name, result.order_value]
  end


  def self.highest_lifetime_orders
    result = User.select("users.*, SUM(products.price * order_contents.quantity) AS lifetime_value").
                  joins("JOIN orders ON users.id = orders.user_id
                         JOIN order_contents ON orders.id = order_contents.order_id
                         JOIN products ON order_contents.product_id = products.id").
                  where("orders.checkout_date IS NOT NULL").
                  group("users.id").
                  order('lifetime_value DESC').
                  first

    [result.first_name, result.last_name, result.lifetime_value]
  end


  def self.highest_average_order
    result = User.select("users.*, SUM(products.price * order_contents.quantity) / COUNT(DISTINCT orders.id) AS average_order_value").
                  joins("JOIN orders ON users.id = orders.user_id
                         JOIN order_contents ON orders.id = order_contents.order_id
                         JOIN products ON order_contents.product_id = products.id").
                  where("orders.checkout_date IS NOT NULL").
                  group("users.id").
                  order('average_order_value DESC').
                  first

    [result.first_name, result.last_name, result.average_order_value]
  end


  def self.most_orders
    result = User.select("users.*, COUNT(DISTINCT orders.id) AS order_count").
                  joins("JOIN orders ON users.id = orders.user_id").
                  where("orders.checkout_date IS NOT NULL").
                  group("users.id").
                  order('order_count DESC').
                  first

    [result.first_name, result.last_name, result.order_count]
  end


end
