module DashboardHelper
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
    Order.joins("JOIN order_contents ON orders.id = order_id")
    .joins("JOIN products ON products.id = product_id")
  end

  def join_table_ua
    User.joins("JOIN addresses ON billing_id = addresses.id")
  end


  def top_three_states
    join_table_ua.joins("JOIN states ON states.id = state_id").select("name").group("name").order("count_name DESC").limit(3).count
  end


end
# Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id").select("SUM(price * quantity)")
#.where("orders.created_at > ?", 7.days.ago)

# Post.joins("JOIN users ON posts.author_id = users.id")
# Order.joins("JOIN users ON users.id = orders.user_id")

#
#
#
# .select(:price, :quantity, "price * quantity AS revenue").where("orders.created_at > ?", days_ago.days.ago).sum(:revenue)



# Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id").where("orders.created_at > ?", days_ago.days.ago).sum
