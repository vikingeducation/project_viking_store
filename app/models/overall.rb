class Overall
  def self.data(num_days = nil)
    [
      user_count(num_days),
      order_count(num_days),
      new_products_count(num_days)
    ]
  end

  def self.user_count(num_days)
    users = User.select('COUNT(*) AS count')
    if num_days
      users = users.where("created_at <= ?", num_days.days.ago)
    end
    ["New Users", users[0].user_count]
  end

  def self.order_count(days)
    orders = Order.select('COUNT(*) AS count')
    if num_days
      orders = orders.where("created_at <= ?", num_days.days.ago)
    end
    ["New Orders", orders[0].count]
  end

  def self.new_products_count(days)
    products = Product.select('COUNT(*) AS count')
    if num_days
      products = products.where("created_at <= ?", num_days.days.ago)
    end
    ["New Products", products[0].count]
  end

  def self.total_revenue(days)
  end
end
