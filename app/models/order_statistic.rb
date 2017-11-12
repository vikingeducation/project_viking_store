class OrderStatistic
  def initialize(from_day: Time.at(0))
    @from_day = from_day
  end

  def number_of_orders
    PlatformAnalysis.new(from_day: @from_day).orders_count
  end

  def total_revenue
    PlatformAnalysis.new(from_day: @from_day).revenue
  end

  def avarage_order_value
    query("AVG(total) AS result")
  end

  def largest_order_value
    query("MAX(total) AS result")
  end

  def number_of_days
    @number_of_days ||= ((@from_day.midnight - 1.day.ago).to_i / 1.day).abs
  end

  def query(query_string)
    table = Order.checkout_from(@from_day).
    select("SUM(products.price) AS total").
    with_products_and_users.
    group("users.id, orders.id")

    Order.select(query_string).from(table).reorder('').
    first.result
  end
end
