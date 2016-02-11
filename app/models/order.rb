class Order < ActiveRecord::Base
  has_many   :order_contents
  belongs_to :user

  def self.recent(num_days = 7)
    Order.processed.where("orders.checkout_date >= ? ", num_days.days.ago.beginning_of_day)
  end

  def self.processed
    Order.where("checkout_date IS NOT NULL")
  end

  def self.total_revenue
    Order.processed.joins("JOIN order_contents ON order_id = orders.id JOIN products ON product_id = products.id ").sum("quantity * price").to_f
  end

  def self.user_order_info(user_id)
    Order.select("orders.id, DATE(orders.created_at) as date, SUM(quantity * price) as totals, orders.checkout_date").
    joins("JOIN order_contents ON order_id = orders.id").
    joins("JOIN products ON order_contents.product_id = products.id").
    where("orders.user_id = #{user_id}").
    order("orders.id").group("orders.id")
  end
    
  def self.order_totals(id)

    Order.joins("JOIN order_contents ON order_id = orders.id JOIN products ON product_id = products.id ").where("orders.id = #{id}").sum("quantity * price").to_f
  end

  def self.top_states
    Order.processed.select("states.name").
      joins("JOIN addresses ON addresses.id = orders.billing_id").
      joins("JOIN states ON states.id = addresses.state_id").
      group("states.name").
      order("COUNT(states.name) DESC").
      limit(3)
      .count
  end

  def self.average_value
    Order.select("order_total").from(Order.order_totals, :orders).average("order_total")
  end

  def self.largest_value
    Order.select("order_total").from(Order.order_totals, :orders).maximum("order_total")
  end

  def self.order_totals
    Order.processed.select("orders.*, SUM(price * quantity) AS order_total").joins("JOIN order_contents ON order_id = orders.id JOIN products ON product_id = products.id").group("orders.id")
  end

  def self.all_order_totals(id=nil)
    ot = Order.select("c.name AS city, u.id as user_id, o.checkout_date, a.street_address, DATE(o.created_at) AS date_placed, o.id, SUM(price * quantity) AS totals")
      .joins("AS o LEFT JOIN users AS u ON o.user_id = u.id")
      .joins("LEFT JOIN addresses AS a ON u.billing_id = a.id")
      .joins("LEFT JOIN cities AS c ON c.id=a.city_id")  
      .joins("LEFT JOIN order_contents AS oc ON oc.order_id = o.id")
      .joins("LEFT JOIN products AS p ON p.id = oc.product_id")
      .order("u.id").group("u.id, o.id,a.id,c.name")
  end

  def self.orders_by_day
    Order.join_days.select("day, COALESCE(SUM(order_total), 0) as sum, COUNT(order_total) as quantity").
      from(Order.order_totals, :orders).
      group("day").
      order("day DESC")
  end

 #Joins orders table by week (empty rows where no orders on week)
  def self.orders_by_week
    Order.join_weeks.select("week, COALESCE(SUM(order_total), 0) as SUM, COUNT(order_total) as quantity").
      from(Order.order_totals, :orders).
      group("week").
      order("week DESC")
  end

  def self.join_days
    Order.joins "RIGHT JOIN GENERATE_SERIES((SELECT DATE(MIN(checkout_date)) FROM orders), CURRENT_DATE, '1 DAY'::INTERVAL) day ON DATE(orders.checkout_date) = day"
  end

  def self.join_weeks
    Order.joins "RIGHT JOIN GENERATE_SERIES((SELECT DATE(DATE_TRUNC('WEEK', MIN(checkout_date))) FROM orders), CURRENT_DATE, '1 WEEK'::INTERVAL) week ON DATE(DATE_TRUNC('WEEK', orders.checkout_date)) = week"
  end
end


  Order.find_by_sql("
    select orders.id AS order, orders.user_id AS user, c.name AS city, a.street_address AS street_address, SUM(price * quantity) AS order_total 
    from orders  
     JOIN order_contents ON order_id = orders.id
     JOIN products ON products.id = product_id 
     JOIN addresses AS a ON a.id = orders.billing_id 
     JOIN cities AS c ON c.id=a.city_id 
     group by orders.id,c.name,a.street_address
    order by orders.id")