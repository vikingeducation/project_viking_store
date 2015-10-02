class Order < ActiveRecord::Base

  def self.within_days(day_range = nil, last_day = DateTime.now)
    if day_range.nil?
      where("checkout_date IS NOT NULL")
    else
      where("checkout_date BETWEEN ? AND ?", last_day - day_range.days, last_day)
    end
  end


  def self.count_orders(day_range = nil, last_day = DateTime.now)
    Order.within_days(day_range, last_day).count
  end



  # for all new orders within past x days
  def self.calc_revenue(day_range = nil)

    if day_range.nil?
      filter_query = Order.join_with_products.where("orders.checkout_date IS NOT NULL")
    else
      filter_query = Order.join_with_products.where("orders.checkout_date > ?", Time.now - day_range.days)
    end

    filter_query.sum("products.price * order_contents.quantity")
  end



  # Pulls stats for a period of time.  Optional arguments for 1) the number of days
  # to include in the range, and 2) the starting date from which to count backwards/
  # Defaults to selecting all days in the database and using the current time as the
  # Starting point.



  def self.order_stats_with_range(number_of_days = nil, last_day = DateTime.now)

    base_query = Order.select("COUNT(DISTINCT orders.id) AS count,
                               SUM(products.price * order_contents.quantity) AS revenue,
                               SUM(products.price * order_contents.quantity) / COUNT(DISTINCT orders.id) AS average").
                        join_with_products

    filter_query = base_query.within_days(number_of_days, last_day).each.first

    {'Number of Orders' => filter_query.count,
    'Total Revenue' => filter_query.revenue,
    'Average Order Value' => filter_query.average,
    'Largest Order Value' => Order.largest_order(number_of_days, last_day)
    }

  end


  def self.largest_order(number_of_days, start)
    base_query = Order.select("orders.id,
                  SUM(products.price * order_contents.quantity) AS order_total").
            join_with_products.
            group("orders.id").
            order("SUM(products.price * order_contents.quantity) DESC")

    if number_of_days.nil?
      full_query = base_query.where("orders.checkout_date IS NOT NULL").first
    else
      full_query = base_query.where("orders.checkout_date BETWEEN ? AND ?", start - number_of_days.days, start).first
    end


    if full_query.nil?
      max_order = nil
    else
      max_order = full_query.order_total
    end

    max_order

  end

  def self.join_with_products
    join_order_with_order_contents.join_order_contents_with_products
  end

  # grabs contents of orders
  def self.join_order_with_order_contents
    joins("JOIN order_contents ON orders.id = order_contents.order_id")
  end

  # grabs products of content
  def self.join_order_contents_with_products
    joins("JOIN products ON order_contents.product_id = products.id")
  end
  
end
