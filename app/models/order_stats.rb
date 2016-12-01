class OrderStats


  def self.data(num_days = nil)
    [ order_count(num_days, 'Number of Orders'),
      total_revenue(num_days, 'Total Revenue'),
      avg_order(num_days),
      largest_order(num_days)
    ]
  end

  def self.avg_order(num_days)
    ["Average Order Value", Order.avg_order_total(num_days)]
  end

  def self.largest_order(num_days)
    ["Largest Order Value", Order.largest_order_total(num_days)]
  end

  def self.order_count(num_days, description = 'Orders')
    [description, Order.count_by_days(num_days)]
  end

  def self.total_revenue(num_days, description = 'Revenue')
    [description, Order.revenue(num_days)]
  end

end
