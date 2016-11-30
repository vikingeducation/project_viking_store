module DashboardHelper


end

# Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id").select("first_name, last_name").group("user_id").limit(1).sum("quantity * price")



# Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id").select("SUM(price * quantity)")
#.where("orders.created_at > ?", 7.days.ago)

# Post.joins("JOIN users ON posts.author_id = users.id")
# Order.joins("JOIN users ON users.id = orders.user_id")

#
#
#
# .select(:price, :quantity, "price * quantity AS revenue").where("orders.created_at > ?", days_ago.days.ago).sum(:revenue)



# Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id").where("orders.created_at > ?", days_ago.days.ago).sum
