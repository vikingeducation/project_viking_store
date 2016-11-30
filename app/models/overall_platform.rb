class OverallPlatform
  def self.data(num_days = nil)
    [
      user_count(num_days),
      order_count(num_days),
      new_products_count(num_days),
      total_revenue(num_days)
    ]
  end

  def self.user_count(num_days)
    users = User.select('COUNT(*) AS count')
    users = users.where("created_at >= ?", num_days.days.ago) if num_days
    [ (num_days ? "New Users" : "Users"), users[0].count]
  end

  def self.order_count(num_days)
    orders = Order.select('COUNT(*) AS count')
    orders = orders.where("created_at >= ?", num_days.days.ago) if num_days
    ["Orders", orders[0].count]
  end

  def self.new_products_count(num_days)
    products = Product.select('COUNT(*) AS count')
    products = products.where("created_at >= ?", num_days.days.ago) if num_days
    [(num_days ? "New Products" : "Products"), products[0].count]
  end

  def self.total_revenue(num_days)
    revenue = Order.select('SUM(price * quantity) AS total')
                   .joins('JOIN order_contents ON (order_id = orders.id)')
                   .joins('JOIN products ON (product_id = products.id)')
    revenue = revenue.where("checkout_date >= ?", num_days.days.ago) if num_days
    ["Revenue", ActionController::Base.helpers.number_to_currency(revenue[0].total)]
  end

end
