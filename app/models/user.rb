class User < ActiveRecord::Base

  def self.get_count(time = nil)
    return self.count if time.nil?
    days_ago = time.days.ago
    self.where("created_at > ?", days_ago).count
  end

#get_top_states/cities shouldn't be here NOTEEE
  def self.get_top_states(num)
    User.select("states.name, COUNT(*) as total")
           .joins("JOIN addresses ON users.billing_id = addresses.id")
           .joins("JOIN states ON states.id = addresses.state_id")
           .group("states.name")
           .order("total DESC")
           .limit(num)
  end
#get_top_states/cities shouldn't be here NOTEEE
  def self.get_top_cities(num)
    User.select("cities.name, COUNT(*) as total")
           .joins("JOIN addresses ON users.billing_id = addresses.id")
           .joins("JOIN cities ON cities.id = addresses.city_id")
           .group("cities.name")
           .order("total DESC")
           .limit(num)
  end

  def self.get_greatest_order
    result = OrderContent.select("orders.user_id, (quantity * price) AS order_sum")
            .joins("JOIN products ON order_contents.product_id = products.id")
            .joins("JOIN orders ON order_contents.order_id = orders.id")
            .where("orders.checkout_date IS NOT NULL")
            .order("order_sum DESC")
            .limit(1)
    search = User.find(result.to_a.first.user_id)
    name = "#{search.first_name} #{search.last_name}"
    total =  result.to_a.first.order_sum.to_f
    {"name" => name, "total" => total}
  end

#inc
  def self.get_lifetime_value
  #total order amount by user
    result = OrderContent.select("orders.user_id, SUM(quantity * price) AS order_sum")
            .joins("JOIN products ON order_contents.product_id = products.id")                          
            .joins("JOIN orders ON order_contents.order_id = orders.id")
            .group("orders.user_id")
            .where("orders.checkout_date IS NOT NULL")
            .order("order_sum DESC")
            .limit(1)
    search = User.find(result.to_a.first.user_id)
    name = "#{search.first_name} #{search.last_name}"
    total =  result.to_a.first.order_sum.to_f
    {"name" => name, "total" => total}
  end


  def self.highest_average_order
    result = OrderContent.select("orders.user_id, ROUND(AVG(quantity * price), 2) AS order_avg")
            .joins("JOIN products ON order_contents.product_id = products.id")                          
            .joins("JOIN orders ON order_contents.order_id = orders.id")
            .group("orders.user_id")
            .where("orders.checkout_date IS NOT NULL")
            .order("order_avg DESC")
            .limit(1)
    search = User.find(result.to_a.first.user_id)
    name = "#{search.first_name} #{search.last_name}"
    total =  result.to_a.first.order_avg.to_f
    {"name" => name, "total" => total}
  end

  def self.most_orders_placed
    result = OrderContent.select("orders.user_id, COUNT(*) AS order_count")
            .joins("JOIN products ON order_contents.product_id = products.id")                          
            .joins("JOIN orders ON order_contents.order_id = orders.id")
            .group("orders.user_id")
            .where("orders.checkout_date IS NOT NULL")
            .order("order_count DESC")
            .limit(1)
    search = User.find(result.to_a.first.user_id)
    name = "#{search.first_name} #{search.last_name}"
    total =  result.to_a.first.order_count.to_i
    {"name" => name, "total" => total}
  end

# result = OrderContent.select("orders.user_id, COUNT(*) AS order_count").joins("JOIN products ON order_contents.product_id = products.id").joins("JOIN orders ON order_contents.order_id = orders.id").group("orders.user_id").order("orders.user_id DESC")
 

end
