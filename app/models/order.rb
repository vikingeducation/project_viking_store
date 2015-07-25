class Order < ActiveRecord::Base

  def self.time_series_day(days=7)

    self.select("date_trunc('day', orders.checkout_date) AS day, count(DISTINCT orders.id), SUM(order_contents.quantity * products.price)").
    join_to_products.
    where('orders.checkout_date >= ? AND orders.checkout_date < ?',
      DateTime.now - 7,DateTime.now).
    group('day').
    order('day DESC')
  end

  def self.time_series_week(weeks=7)

    self.select("date_trunc('week', orders.checkout_date) AS week, count(DISTINCT orders.id), SUM(order_contents.quantity * products.price)").
    join_to_products.
    where('orders.checkout_date >= ? AND orders.checkout_date < ?',
      DateTime.now - (7 * weeks), DateTime.now).
    group('week').
    order('week DESC')
  end

  def self.get_statistics
    overall = {'Last 7 Days' => 7, 'Last 30 Days' => 30, 'Total' => nil}
    overall.each do |key, limit|
      result = []
      result << ["Number of Orders", self.in_last(limit)]
      result << ["Total Revenue", self.revenue_in_last(limit)]
      result << ["Average Order Value", self.average_in_last(limit)]
      result << ["Largest Order Value", self.largest_in_last(limit)]
      overall[key] = result
    end
    overall
  end

  def self.in_last(days=nil)
    if days.nil?
      self.count
    else
      self.where('checkout_date > ?', DateTime.now - days).count
    end
  end

  def self.revenue_in_last(days=nil)
    if days
      revenue.where('orders.checkout_date IS NOT NULL').first.cost
    else
      revenue.where('orders.checkout_date > ?', DateTime.now - days).first.cost
    end
  end

  def self.avg_in_last_helper
    self.select('(SUM(products.price * order_contents.quantity)/COUNT(DISTINCT orders.id)) as average_order').
      join_to_products
  end

  def self.average_in_last(days = nil)
    if days
      self.avg_in_last_helper.
      where('orders.checkout_date > ?', DateTime.now - days).order('1').first.average_order
    else
      self.avg_in_last_helper.
      where('orders.checkout_date IS NOT NULL').order('1').first.average_order
    end
  end


  def self.largest_in_last(days = nil)
    if days
      self.get_largest_overall.
      where('orders.checkout_date > ?', DateTime.now - days).
      group('orders.id').order('max_order DESC').first.max_order
    else
      self.get_largest_overall.
      where('orders.checkout_date IS NOT NULL').
      group('orders.id').order('max_order DESC').first.max_order
    end
  end

  def self.revenue_in_last(days)
    self.revenue(days).first.cost
  end

  private

  def self.get_largest_overall
    self.select('SUM(products.price * order_contents.quantity) as max_order').
    join_to_products
  end

  def self.revenue(days = nil)
    if days
      self.select('SUM(products.price * order_contents.quantity) as cost').
      join_to_products.
      where('orders.checkout_date > ?', DateTime.now - days).order('cost')
    else
      self.select('SUM(products.price * order_contents.quantity) as cost').
      join_to_products.
      order('cost')
    end
  end

  def self.join_to_order_contents
    self.joins('JOIN order_contents ON orders.id = order_contents.order_id')
  end

  def self.join_to_products
    self.join_to_order_contents.joins('JOIN products ON products.id = order_contents.product_id')
  end
end
