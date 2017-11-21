class Admin::Analysis::OrderStatistic
  def self.from(*times)
    result = times.flatten.map { |time| new(from_day: time) }
    result.one? ? result.first : result
  end

  def initialize(from_day: Time.at(0))
    @from_day = from_day
  end

  def number_of_orders
    Order.checkout_from(@from_day).count
  end

  def total_revenue
    Order.checkout_from(@from_day).total_revenue
  end

  def avarage_order_value
    Order.checkout_from(@from_day).order("avg DESC").with_products.limit(1).
    pluck("AVG(products.price * order_contents.quantity) AS avg").first
  end

  def largest_order_value
    Order.checkout_from(@from_day).order("sum DESC").total
  end

  def number_of_days
    @number_of_days ||= ((@from_day.midnight - 1.day.ago).to_i / 1.day).abs
  end
end
