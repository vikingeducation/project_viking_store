class OverallPlatform
  def self.data(num_days = nil)
    [
      user_count(num_days),
      OrderStats.order_count(num_days),
      new_products_count(num_days),
      OrderStats.total_revenue(num_days)
    ]
  end

  def self.user_count(num_days)
    [ (num_days ? "New Users" : "Users"), User.count_by_days(num_days)]
  end

  def self.new_products_count(num_days)
    [(num_days ? "New Products" : "Products"), Product.count_by_days(num_days)]
  end

end
