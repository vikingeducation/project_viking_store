class OrderStats


  def self.data(num_days = nil)
    [ order_count(num_days, 'Number of Orders'),
      total_revenue(num_days, 'Total Revenue'),
      
    ]
  end

  def self.order_count(num_days, description = 'Orders')
    [description, Order.count_by_days(num_days)]
  end

  def self.total_revenue(num_days, description = 'Revenue')
    [description, Order.revenue(num_days)]
  end

end