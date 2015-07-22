class Order < ActiveRecord::Base
  belongs_to :user
  has_many :order_contents, :class_name => "OrderContents"
  has_many :products, :through => :order_contents
  has_many :categories, :through => :products

  belongs_to :billing_address, :class_name => 'Address', :foreign_key => :billing_id
  belongs_to :shipping_address, :class_name => 'Address', :foreign_key => :shipping_id


# Portal methods
  def calculate_order_value
    self.products.sum("order_contents.quantity * products.price")
  end



# Dashboard methods
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
=begin
Order.select("orders.id, COUNT(DISTINCT orders.id) AS count,
                                SUM(products.price * order_contents.quantity) AS revenue,
                                SUM(products.price * order_contents.quantity) / COUNT(DISTINCT orders.id) AS average").
                        joins("JOIN order_contents ON orders.id = order_contents.order_id
                              JOIN products ON order_contents.product_id = products.id").
                        where("orders.checkout_date BETWEEN ? AND ?", Time.now - 7.days, Time.now)
=end



  def self.order_stats_by_day_range(number_of_days = nil, start = Time.now)

    base_query = Order.select("COUNT(DISTINCT orders.id) AS count,
                                SUM(products.price * order_contents.quantity) AS revenue,
                                SUM(products.price * order_contents.quantity) / COUNT(DISTINCT orders.id) AS average").
                        joins("JOIN order_contents ON orders.id = order_contents.order_id
                              JOIN products ON order_contents.product_id = products.id")

    if number_of_days.nil?
      filter_query = base_query.where("orders.checkout_date IS NOT NULL").each.first
    else
      filter_query = base_query.where("orders.checkout_date BETWEEN ? AND ?", start - number_of_days.days, start).each.first
    end


    {'Number of Orders' => filter_query.count,
    'Total Revenue' => filter_query.revenue,
    'Average Order Value' => filter_query.average,
    'Largest Order Value' => Order.largest_order(number_of_days, start)
    }

  end


  def self.largest_order(number_of_days, start)
    base_query = Order.select("orders.id,
                  SUM(products.price * order_contents.quantity) AS order_total").
            joins("JOIN order_contents ON orders.id = order_contents.order_id
                  JOIN products ON order_contents.product_id = products.id").
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


end