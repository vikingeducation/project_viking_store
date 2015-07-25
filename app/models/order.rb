class Order < ActiveRecord::Base

  def self.time_series_day(days=7)

    self.select("date_trunc('day', orders.checkout_date) AS day, count(DISTINCT orders.id), SUM(order_contents.quantity * products.price)").
    joins('JOIN order_contents ON orders.id = order_contents.order_id').
    joins('JOIN products ON products.id = order_contents.product_id').
    where('orders.checkout_date >= ? AND orders.checkout_date < ?',
      DateTime.now - 7,DateTime.now).
    group('day').
    order('day DESC')
  end

  def self.time_series_week(weeks=7)

    self.select("date_trunc('week', orders.checkout_date) AS week, count(DISTINCT orders.id), SUM(order_contents.quantity * products.price)").
    joins('JOIN order_contents ON orders.id = order_contents.order_id').
    joins('JOIN products ON products.id = order_contents.product_id').
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
    if days.nil?
      revenue.where('orders.checkout_date IS NOT NULL').first.cost
    else
      revenue.where('orders.checkout_date > ?', DateTime.now - days).first.cost
    end
  end

  def self.average_in_last(days = nil)
    unless days.nil?
      self.select('(SUM(products.price * order_contents.quantity)/COUNT(DISTINCT orders.id)) as average_order').
      joins('JOIN order_contents ON order_contents.order_id = orders.id').
      joins('JOIN products ON order_contents.product_id = products.id').
      where('orders.checkout_date > ?', DateTime.now - days).order('1').first.average_order
    else
      self.select('(SUM(products.price * order_contents.quantity)/COUNT(DISTINCT orders.id)) as average_order').
      joins('JOIN order_contents ON order_contents.order_id = orders.id').
      joins('JOIN products ON order_contents.product_id = products.id').
      where('orders.checkout_date IS NOT NULL').order('1').first.average_order
    end
  end

  def self.largest_in_last(days = nil)
    unless days.nil?
      self.select('SUM(products.price * order_contents.quantity) as max_order').
      joins('JOIN order_contents ON order_contents.order_id = orders.id').
      joins('JOIN products ON order_contents.product_id = products.id').
      where('orders.checkout_date > ?', DateTime.now - days).
      group('orders.id').order('max_order DESC').first.max_order
    else
      self.select('SUM(products.price * order_contents.quantity) as max_order').
      joins('JOIN order_contents ON order_contents.order_id = orders.id').
      joins('JOIN products ON order_contents.product_id = products.id').
      where('orders.checkout_date IS NOT NULL').
      group('orders.id').order('max_order DESC').first.max_order
    end
  end

  def self.revenue_in_last(days)
    self.revenue(days).first.cost
  end

  private
    def self.revenue(days=nil)
      unless days
      self.select('SUM(products.price * order_contents.quantity) as cost').joins(
        'JOIN order_contents ON orders.id = order_contents.
        order_id JOIN products ON order_contents.product_id = products.id').order('cost')
      else
        self.select('SUM(products.price * order_contents.quantity) as cost').joins(
        'JOIN order_contents ON orders.id = order_contents.
        order_id JOIN products ON order_contents.product_id = products.id').
        where('orders.checkout_date > ?', DateTime.now - days).order('cost')
      end
    end
end
