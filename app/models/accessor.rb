  # accessor.rb ... project viking store ... DAVID WIESENBERG

  # helper methods to calculate results for Dashboard

module Accessor

  # ###################################################################
  # 1. Overall Platform # totals for past 7 days, 30 days, and all time

  def total_users(days_ago)
    User.all.where("created_at >=?", days_ago.days.ago).count
  end

  def total_orders(days_ago)
    Order.all.where("checkout_date >=?", days_ago.days.ago).count
  end

  def total_new_products(days_ago)
    Product.all.where("created_at >=?", days_ago.days.ago).count
  end

  def join_table_ord_ordcont_prod
    Order
    .joins("JOIN order_contents
      ON orders.id = order_contents.order_id")
    .joins("JOIN products 
      ON products.id = order_contents.product_id")
  end

  def total_revenue(days_ago)
    join_table_ord_ordcont_prod
    .where("orders.checkout_date > ?", days_ago.days.ago)
    .sum("order_contents.quantity * products.price")
  end

  # #################################
  # 2. User demographics and Behavior

  def join_table_users_addresses
    User
    .joins("JOIN addresses
      ON users.billing_id = addresses.id")
  end

  # Top Three States Users Live In (Billing)

  def top_three_states
    join_table_users_addresses
    .joins("JOIN states 
      ON addresses.state_id = states.id")
    .select("states.name, count(states.name) AS count_in_states")
    .group("states.name")
    .order("count(states.name) DESC")
    .limit(3)
  end

  # Top Three Cities Users Live In (Billing)

  def top_three_cities
    join_table_users_addresses
    .joins("JOIN cities
      ON addresses.city_id = cities.id")
    .select("cities.name, count(cities.name) AS count_in_cities")
    .group("cities.name")
    .order("count(cities.name) DESC")
    .limit(3)
  end

  # Top User With ...

  def join_table_ord_ordcont_prod_users
    Order
    .joins("JOIN order_contents
      ON orders.id = order_contents.order_id")
    .joins("JOIN products 
      ON products.id = order_contents.product_id")
    .joins("JOIN users
      ON users.id = orders.user_id")
  end

  # ... Highest Single Order Value

  def highest_single_order_value
    join_table_ord_ordcont_prod_users
    .select("users.first_name AS user_name, SUM(products.price * order_contents.quantity) AS order_value")
    .group("user_name, orders.id")
    .order("order_value DESC")
    .limit(1)
  end

  # ... Highest Lifetime Value

  def highest_lifetime_order_value
    join_table_ord_ordcont_prod_users
    .select("users.first_name || ' ' || users.last_name AS user_name, SUM(products.price * order_contents.quantity) AS lifetime_order_value")
    .group("user_name, users.id")
    .order("lifetime_order_value DESC")
    .limit(1)
  end

  # ... Highest Average Order Value

  def highest_average_order_value
    join_table_ord_ordcont_prod_users
    .select("users.first_name || ' ' || users.last_name AS user_name, 
      AVG(products.price * order_contents.quantity) AS average_order_value")
    .group("user_name, users.id")
    .order("average_order_value DESC")
    .limit(1)
  end

  # ... Most Orders Placed

  def join_table_ord_users
    Order
    .joins("JOIN users
      ON users.id = orders.user_id")
  end

  def most_orders_placed
    join_table_ord_users
    .select("users.first_name || ' ' || users.last_name AS user_name, 
      COUNT(orders.user_id) AS most_orders_placed")
    .group("user_name, users.id")
    .order("most_orders_placed DESC")
    .limit(1)
  end




  # ###################################################################
  # 3. Order statistics # totals for past 7 days, 30 days, and all time

  def total_orders(days_ago)
    Order.all.where("checkout_date >=?", days_ago.days.ago).count
  end

  def total_revenue(days_ago)
    join_table_ord_ordcont_prod
    .where("orders.checkout_date > ?", days_ago.days.ago)
    .sum("order_contents.quantity * products.price")
  end

  def average_order_value(days_ago)
    join_table_ord_ordcont_prod
    .where("orders.checkout_date > ?", days_ago.days.ago)
    .select("SUM(products.price * order_contents.quantity)/COUNT(DISTINCT orders.id) AS average_order_value")
  end

  def largest_order_value(days_ago)
    join_table_ord_ordcont_prod
    .where("orders.checkout_date > ?", days_ago.days.ago)
    .select("SUM(products.price * order_contents.quantity) AS largest_order_value")
    .group("orders.id")
    .order("SUM(products.price * order_contents.quantity) DESC")
    .limit(1)
  end


  # ###################
  # 4. Time series data

  def orders_by_day
      join_table_ord_ordcont_prod 
      .select("date_trunc('day', orders.checkout_date) AS date, COUNT(DISTINCT orders.id) AS quantity, SUM(products.price * order_contents.quantity) AS value")
      .where("orders.checkout_date > ?", 7.days.ago)
      .group("date_trunc('day', orders.checkout_date)")
      .order("date_trunc('day', orders.checkout_date) DESC")
  end

  def orders_by_week
      join_table_ord_ordcont_prod 
      .select("date_trunc('week', orders.checkout_date) AS date, COUNT(DISTINCT orders.id) AS quantity, SUM(products.price * order_contents.quantity) AS value")
      .where("orders.checkout_date > ?", 7.weeks.ago)
      .group("date_trunc('week', orders.checkout_date)")
      .order("date_trunc('week', orders.checkout_date) DESC")
  end


# Testing

# Order.joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON products.id = order_contents.product_id")


# Order.joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON products.id = order_contents.product_id").select("date_trunc('day', orders.checkout_date) AS date, COUNT(DISTINCT orders.id) AS quantity, SUM(products.price * order_contents.quantity) AS value").group("date_trunc('day', orders.checkout_date)").order("date_trunc('day', orders.checkout_date) DESC").where("orders.checkout_date > ?", 7.days.ago).limit(20)


# Order.joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON products.id = order_contents.product_id").select("date_trunc('week', orders.checkout_date) AS date, COUNT(DISTINCT orders.id) AS quantity, SUM(products.price * order_contents.quantity) AS value").group("date_trunc('week', orders.checkout_date)").order("date_trunc('week', orders.checkout_date) DESC").where("orders.checkout_date > ?", 7.weeks.ago).limit(20)



# Order.where("created_at IN (?)", (Time.now - 30.days .. Time.now) ).all.limit(10)

# Order.select("7, COUNT(*)").limit(10)

# Order.where("created_at IN (?)", (Time.now - 30.days).all_day() ).select("(Time.now - 30.days), COUNT(id)") 


  # # ##################
  # Order.where("created_at IN (?)", (Time.now - 30.days).all_day() ).select("30, COUNT(id)")


  # Client.all(:conditions => ["created_at IN (?)",
  #   (params[:start_date].to_date)..(params[:end_date].to_date)])

  # where(:created_at => test.start_time..test.end_time)
  # # ##################

  # def orders_by_week
  #   daily_orders = []
  #   (0..6).times do |weeks_ago|
  #     daily_orders << Order
  #       .where("created_at = ?", 
  #         (Time.now - weeks_ago.weeks).all_week() )
  #       .select("(Time.now - weeks_ago.weeks), COUNT(id)") 
  #         # beginning_of_week() is always a Monday
  #   end
  # end


  # Note. One cannot convert date to string here in SQL ... do it in view (erb file)
  #      .select("(strftimeTime.now - days_ago.days).('%_m/%-d') ...") 
  #      .select("(Time.now - weeks_ago.weeks).beginning_of_week().strftime('%_m/%-d'), COUNT(id)")  
  # but one can convert to a string AFTER the select item ... 
  # eg select( .... ).strftime('%_m/%-d')

  # Order.where("created_at = ?", (Time.now - 30.days).all_day() ).select("(Time.now - days_ago.days)").limit(5)

end
  # ###############################################################

  # Francisco's solution

  # module Accessor
  #   def total_users(days_ago)
  #     User.all.where("created_at >= ?", days_ago.days.ago).count
  #   end

  #   def total_orders(days_ago)
  #     Order.all.where("checkout_date >  ?", days_ago.days.ago).count
  #   end

  #   def total_new_products(days_ago)
  #     Product.all.where("created_at >= ?", days_ago.days.ago).count
  #   end

  #   def total_revenue(days_ago)
  #     join_table_op
  #     .where("checkout_date > ?", days_ago.days.ago)
  #     .sum("quantity * price")
  #   end

  #   def join_table_op #order to product
  #     Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id")
  #   end

  #   def join_table_ua
  #     User.joins("JOIN addresses ON billing_id = addresses.id")
  #   end

  #   def top_three_states
  #     join_table_ua.joins("JOIN states ON states.id = state_id").select("name").group("name").order("count_name DESC").limit(3).count
  #   end

  #   def top_three_cities
  #     join_table_ua.joins("JOIN cities ON cities.id = city_id").select("name").group("name").order("count_name DESC").limit(3).count
  #   end

  #   def highest_user_value_id
  #      join_table_op.select("order_id", "SUM(quantity*price) AS profit" ).group("order_id").order("profit DESC").limit(1).first

  #   end

  #   def highest_lifetime_value_id
  #     join_table_op.select("user_id", "SUM(quantity*price) AS profit" ).group("user_id").order("profit DESC").limit(1).first
  #   end

  #   def highest_avg_order_value_id
  #     join_table_op.select("user_id", "AVG(quantity*price) AS profit" ).group("user_id").order("profit DESC").limit(1).first
  #   end

  #   def highest_avg_order_value
  #     holder = highest_avg_order_value_id
  #     user = User.find(holder.user_id)
  #     [holder.profit, user.first_name, user.last_name]
  #   end

  #   def highest_lifetime_value
  #     profit_holder = highest_lifetime_value_id
  #     user = User.find(profit_holder.user_id)
  #     [profit_holder.profit, user.first_name, user.last_name]
  #   end

  #   def highest_user_order_value
  #     profit_holder = highest_user_value_id
  #     user_id = Order.find(profit_holder.order_id).user_id
  #     user = User.find(user_id)
  #     [profit_holder.profit, user.first_name, user.last_name]
  #   end

  # ##
  #   def most_orders_placed_id
  #     Order.select("user_id, count(user_id) AS total").group("user_id").order("total DESC").limit(1).first
  #   end

  #   def most_orders_placed
  #     holder = most_orders_placed_id
  #     user = User.find(holder.user_id)
  #     [holder.total, user.first_name, user.last_name]
  #   end

  #   def average_order_value(days_ago)
  #     Order.from(Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id").select("order_id", "quantity*price AS profit" ).where("checkout_date > ?", days_ago.days.ago).group("order_id, profit"), :profits).average("profits.profit").to_i
  #   end

  #   def largest_order_value(days_ago)
  #     Order.from(Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id").select("user_id", "quantity*price AS profit" ).where("checkout_date > ?", days_ago.days.ago).group("user_id, profit"), :profits).maximum("profits.profit").to_i
  #   end

  # #grab all orders where date
  # #group by order_id

  # # Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id")
  # #
  # # Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id").select("user_id", "SUM(quantity*price) AS profit" ).where("checkout_date > ?", days_ago.days.ago).group("user_id").average(profit)
  # #
  # # Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id").select("user_id").where("checkout_date > ?", 7.days.ago).average("quantity*price")
  #   # def total_orders(days_ago)
  #   #   Order.where("checkout_date > ?", days_ago.days.ago)
  #   # end

  # #Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id").select("user_id", "AVG(quantity*price) AS profit" ).group("user_id").order("profit DESC").limit(1).first




  # #returns order id, amount spent, user order id to find user name

  # end
