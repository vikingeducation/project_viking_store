class User < ApplicationRecord
  has_many :addresses, dependent: :destroy
  has_many :credit_cards, dependent: :destroy
  has_many :orders

  def self.get_num_of_new_users(start = Time.now, days_ago = nil)
    result = User.select("count(*) AS num_new_users")
    unless days_ago.nil?
      result = result.where("users.created_at <= '#{start}' AND users.created_at >= '#{start - days_ago.days}'")
    end
    result[0].num_new_users.to_s
  end

  def self.top_states(limit = 3)
    state_demos = []
    result = User.select("states.name AS state_name, COUNT(*) AS state_count")
                .joins("JOIN addresses ON users.billing_id = addresses.user_id")
                .joins("JOIN states ON addresses.state_id = states.id")
                .group("states.id")
                .order("COUNT(*) DESC")
                .limit(limit)
    result.each { |r| state_demos << [r.state_name, r.state_count] }
    state_demos
  end

  def self.top_cities(limit = 3)
    city_demos = []
    result = User.select("cities.name AS city_name, COUNT(*) AS city_count")
                .joins("JOIN addresses ON users.billing_id = addresses.user_id")
                .joins("JOIN cities ON addresses.city_id = cities.id")
                .group("cities.id")
                .order("COUNT(*) DESC")
                .limit(limit)            
    result.each { |r| city_demos << [r.city_name, r.city_count] }
    city_demos
  end

  def self.highest_single_order_value(limit = 1)
    highest_single_order_value = []
    result = User.select("users.first_name, users.last_name, SUM(order_contents.quantity * products.price) AS order_total")
            .join_users_orders_order_contents_and_products
            .where("orders.checkout_date IS NOT NULL")
            .group("users.id, orders.id")
            .order("SUM(order_contents.quantity * products.price) DESC")
            .limit(limit)
    result.each { |r| highest_single_order_value << ["#{r.first_name} #{r.last_name}", sprintf('$%.2f', r.order_total)] }
    highest_single_order_value
  end

  def self.highest_lifetime_value(limit = 1)
    highest_lifetime_value = []
    result = User.select("users.id, users.first_name, users.last_name, SUM(order_contents.quantity * products.price) AS lifetime_value")
            .join_users_orders_order_contents_and_products
            .where("orders.checkout_date IS NOT NULL")
            .group("users.id")
            .order("SUM(order_contents.quantity * products.price) DESC")
            .limit(limit)
    result.each { |r| highest_lifetime_value << ["#{r.first_name} #{r.last_name}", sprintf('$%.2f', r.lifetime_value)] }
    highest_lifetime_value
  end

  def self.highest_average_order_value(limit = 1)
    highest_average_order_value = []
    result = User.find_by_sql("
      SELECT users.id, users.first_name, users.last_name, AVG(all_orders.order_total) AS average_order_value
      FROM users JOIN 
        (SELECT orders.id, orders.user_id AS user_id, SUM(order_contents.quantity * products.price) AS order_total
          FROM users JOIN orders ON users.id = orders.user_id 
          JOIN order_contents ON orders.id = order_contents.order_id 
          JOIN products ON order_contents.product_id = products.id 
          WHERE orders.checkout_date IS NOT NULL 
          GROUP BY orders.id) AS all_orders ON users.id = all_orders.user_id 
      GROUP BY users.id 
      ORDER BY average_order_value DESC
      LIMIT #{limit};
      ")
      result.each { |r| highest_average_order_value << ["#{r.first_name} #{r.last_name}", sprintf('$%.2f', r.average_order_value)] }
      highest_average_order_value
  end 

  def self.most_orders_placed(limit = 1)
    most_orders_placed = []
    result = User.select("users.id, users.first_name, users.last_name, COUNT(*) AS order_count")
                .join_users_to_orders
                .where("orders.checkout_date IS NOT NULL")
                .group("users.id")
                .order("COUNT(*) DESC")
                .limit(limit)
    result.each { |r| most_orders_placed << ["#{r.first_name} #{r.last_name}", r.order_count.to_s] }
    most_orders_placed
  end

  private

  def self.join_users_to_orders
    joins("JOIN orders ON users.id = orders.user_id")
  end

  def self.join_users_orders_order_contents_and_products
    join_users_to_orders
    .joins("JOIN order_contents ON orders.id = order_contents.order_id")
    .joins("JOIN products ON order_contents.product_id = products.id")
  end
end
