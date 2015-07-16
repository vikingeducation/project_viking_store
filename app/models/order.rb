class Order < ActiveRecord::Base

  def self.count_orders(day_range = nil)
    if day_range.nil?
      Order.where("checkout_date IS NOT NULL").count
    else
      Order.where("checkout_date > ?", Time.now - day_range.days).count
    end
  end



  # for all new orders within past x days
  def self.calc_revenue(day_range = nil)
    base_query = Order.joins("JOIN order_contents ON orders.id = order_contents.order_id
                 JOIN products ON order_contents.product_id = products.id")

    if day_range.nil?
      filter_query = base_query.where("orders.checkout_date IS NOT NULL")
    else
      filter_query = base_query.where("orders.checkout_date > ?", Time.now - day_range.days)
    end

    filter_query.sum("products.price * order_contents.quantity")
  end



  # Pulls stats for a period of time.  Optional arguments for 1) the number of days
  # to include in the range, and 2) the starting date from which to count backwards/
  # Defaults to selecting all days in the database and using the current time as the
  # Starting point.
  def self.order_stats_by_day_range(number_of_days = nil, start = Time.now)
    base_query = Order.select("COUNT(DISTINCT orders.id) AS count,
                                SUM(products.price * order_contents.quantity) AS revenue,
                                MAX(products.price * order_contents.quantity) AS maximum,
                                SUM(products.price * order_contents.quantity) / COUNT(DISTINCT orders.id) AS average").
                        joins("JOIN order_contents ON orders.id = order_contents.order_id
                              JOIN products ON order_contents.product_id = products.id")

    if number_of_days.nil?
      full_query = base_query.where("orders.checkout_date IS NOT NULL").first
    else
      full_query = base_query.where("orders.checkout_date BETWEEN ? AND ?", start - number_of_days.days, start).first
    end

    {'Number of Orders' => full_query.count,
    'Total Revenue' => full_query.revenue,
    'Average Order Value' => full_query.average,
    'Largest Order Value' => full_query.maximum
    }

  end


end