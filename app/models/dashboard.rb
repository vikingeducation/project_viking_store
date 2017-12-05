class Dashboard

  def last_n_days_count(n, klass)
    klass.last_n_days(n).count
  end

  def total_count(klass)
    klass.count
  end

  def total_revenue
    Order.total_revenue
  end

  def total_revenue_last_n_days(n)
    Order.last_n_days(n).total_revenue
  end

  def top_states
    Address.top_3_states
  end

  def top_cities
    Address.top_3_cities
  end

  def highest_value_order
    Order.highest_value
  end


end
