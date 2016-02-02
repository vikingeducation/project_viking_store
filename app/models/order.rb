class Order < ActiveRecord::Base
  has_many :order_contents

  def self.recent(num_days = 7)
    Order.processed.where("orders.checkout_date >= ? ", num_days.days.ago.beginning_of_day)
  end

  def self.total_revenue
    Order.processed.joins("JOIN order_contents ON order_id = orders.id JOIN products ON product_id = products.id ").sum("quantity * price").to_f
  end

  def self.processed
    Order.where("checkout_date IS NOT NULL")
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


  def self.orders_by_day
     # Order.select("SUM(order_total), COUNT(*)").from(Order.order_totals, :orders).where(checkout_date: (num_days.days.ago.beginning_of_day..num_days.days.ago.end_of_day))

     Order.select("DATE(checkout_date),SUM(order_total), COUNT(*)").from(Order.order_totals, :orders).group("DATE(checkout_date)")
  end
end
