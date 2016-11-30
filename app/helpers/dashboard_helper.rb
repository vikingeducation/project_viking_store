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
    join_table
    .select("SUM(price * quantity)")
    .where("orders.created_at > ?", days_ago.days.ago)

  end

  def join_table #order to product
    Order.joins("JOIN order_contents ON orders.id = order_id")
    .joins("JOIN products ON products.id = product_id")
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
