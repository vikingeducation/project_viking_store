module Accessor
  def total_users(days_ago)
    User.all.where("created_at >  ?", days_ago.days.ago).count
  end

  def total_orders(days_ago)
    Order.all.where("checkout_date >  ?", days_ago.days.ago).count
  end

  def total_new_products(days_ago)
    Product.all.where("created_at >  ?", days_ago.days.ago).count
  end

  def total_revenue(days_ago)
    join_table_op
    .where("checkout_date > ?", days_ago.days.ago)
    .sum("quantity * price")
  end

  def join_table_op #order to product
    Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id")
  end

  def join_table_ua
    User.joins("JOIN addresses ON billing_id = addresses.id")
  end

  def top_three_states
    join_table_ua.joins("JOIN states ON states.id = state_id").select("name").group("name").order("count_name DESC").limit(3).count
  end

  def top_three_cities
    join_table_ua.joins("JOIN cities ON cities.id = city_id").select("name").group("name").order("count_name DESC").limit(3).count
  end

  def highest_user_value_id
     join_table_op.select("order_id", "SUM(quantity*price) AS profit" ).group("order_id").order("profit DESC").limit(1).first

  end

  def highest_lifetime_value_id
    join_table_op.select("user_id", "SUM(quantity*price) AS profit" ).group("user_id").order("profit DESC").limit(1).first
  end

  def highest_avg_order_value_id
    all_orders_and_profit = join_table_op.select("order_id", "user_id", "SUM(quantity*price) AS profit" ).group("order_id, user_id")
    all_orders_and_profit.
  end

  def highest_lifetime_value
    profit_holder = highest_lifetime_value_id
    user = User.find(profit_holder.user_id)
    [profit_holder.profit, user.first_name, user.last_name]
  end

  def highest_user_order_value
    profit_holder = highest_user_value_id
    user_id = Order.find(profit_holder.order_id).user_id
    user = User.find(user_id)
    [profit_holder.profit, user.first_name, user.last_name]
  end

#returns order id, amount spent, user order id to find user name

end