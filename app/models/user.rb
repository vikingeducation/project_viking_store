class User < ActiveRecord::Base

  def self.count_new_users(day_range = nil)

    if day_range.nil?
      User.all.count
    else
      User.where("created_at > ?", Time.now - day_range.days).count
    end

  end

  def self.top_3_by_state

    User.join_with_states.
         group("states.name").
         order("count(distinct users.id) DESC").
         limit(3).
         count(:id)

  end

  def self.top_3_by_city

    User.join_with_cities.
         group("cities.name").
         order("count(distinct users.id) DESC").
         limit(3).
         count(:id)

  end

  def self.top_users

    { 'Highest Single Order Value' => self.highest_value,
      'Highest Lifetime Value' => self.highest_lifetime_value,
      'Highest Average Order Value' => self.highest_average_order,
      'Most Orders Placed' => self.most_orders
    }

  end

  def self.highest_value

    # group by user then order gives single order highest value
    result = User.select("users.*, orders.id AS order_id, SUM(products.price * order_contents.quantity) AS order_value").
                  join_users_with_orders.
                  where("orders.checkout_date IS NOT NULL").
                  group("users.id, orders.id").
                  order('order_value DESC').
                  first

    [result.first_name + " " + result.last_name, result.order_value]

  end

  def self.highest_lifetime_value

    # group by users gives lifetime value
    result = User.select("users.*, SUM(products.price * order_contents.quantity) AS lifetime_value").
                  join_users_with_orders.
                  where("orders.checkout_date IS NOT NULL").
                  group("users.id").
                  order('lifetime_value DESC').
                  first

    [result.first_name + " " + result.last_name, result.lifetime_value]

  end

  def self.highest_average_order

    result = User.select("users.*, round( SUM(products.price * order_contents.quantity) / COUNT(DISTINCT orders.id), 2) AS average_order_value").
                  join_users_with_orders.
                  where("orders.checkout_date IS NOT NULL").
                  group("users.id").
                  order('average_order_value DESC').
                  first

    [result.first_name + " " + result.last_name, result.average_order_value]

  end

  def self.most_orders

    result = User.select("users.*, COUNT(DISTINCT orders.id) AS order_count").
                  joins("JOIN orders ON users.id = orders.user_id").
                  where("orders.checkout_date IS NOT NULL").
                  group("users.id").
                  order('order_count DESC').
                  first

    [result.first_name + " " + result.last_name, result.order_count]

  end

  def self.join_with_states
    join_with_addresses.joins("JOIN states ON addresses.state_id = states.id")
  end

  def self.join_with_cities
    join_with_addresses.joins("JOIN cities ON addresses.city_id = cities.id")
  end

  def self.join_with_addresses
    joins("JOIN addresses ON users.billing_id = addresses.id")
  end

  def self.join_users_with_orders

    joins("JOIN orders ON users.id = orders.user_id
           JOIN order_contents ON orders.id = order_contents.order_id
           JOIN products ON order_contents.product_id = products.id")

  end

end
