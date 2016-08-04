class OrderContent < ActiveRecord::Base

  def self.get_completed_orders
    joins('JOIN products ON (order_contents.product_id = products.id)')
          .joins('JOIN orders ON (order_contents.order_id = orders.id)')
          .where("checkout_date IS NOT NULL")
  end

  def self.day_revenue(day)
    get_completed_orders.where("checkout_date > ? ", day.days.ago)
                .sum('products.price * order_contents.quantity')
  end

  def self.total_revenue
    get_completed_orders.sum('products.price * order_contents.quantity')
  end

  def self.day_orders(day)
    get_completed_orders.where("checkout_date > ? ", day.days.ago).count
  end

  def self.total_orders
    get_completed_orders.count
  end

  def self.largest_order(day)
    get_completed_orders.where("checkout_date > ? ", day.days.ago)
                    .maximum('products.price * order_contents.quantity')

  end


  def self.largest_order_total
    get_completed_orders.maximum('products.price * order_contents.quantity')

  end

  def self.average_order(day)
     get_completed_orders.where("checkout_date > ? ", day.days.ago)
                    .average('products.price * order_contents.quantity')
  end

  def self.average_order_total
    get_completed_orders.average('products.price * order_contents.quantity')
  end

  def self.order_num_on_day(day)
    get_completed_orders
    .where("checkout_date BETWEEN ? AND ? ", (day+1).days.ago, day.days.ago).count
  end

   def self.order_value_on_day(day)
    get_completed_orders
    .where("checkout_date BETWEEN ? AND ? ", (day+1).days.ago, day.days.ago).sum('products.price * order_contents.quantity')
  end

  def self.order_num_on_week(week)
    get_completed_orders
    .where("checkout_date BETWEEN ? AND ? ", (week+1).weeks.ago, week.weeks.ago).count
  end

    def self.order_value_on_week(week)
    get_completed_orders
    .where("checkout_date BETWEEN ? AND ? ", (week+1).weeks.ago, week.weeks.ago).sum('products.price * order_contents.quantity')
  end
end
