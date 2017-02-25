class Order < ApplicationRecord

  def self.new_orders_count(days=nil, n=0)
    o = Order.where("checkout_date IS NOT NULL #{days_ago(days, n)}").count
  end

  def self.recent_revenue(days=nil, n=0)
    r = Order.join_orders_with_order_contents.join_orders_with_products.where("checkout_date IS NOT NULL #{days_ago(days, n)}").sum('price * quantity').to_i
  end

  def self.avg_order_val(days=nil, n=0)
    r = Order.join_orders_with_order_contents.join_orders_with_products.where("checkout_date IS NOT NULL #{days_ago(days, n)}").average('price * quantity').to_i
  end

  def self.by_day(limit=7)
    orders = OrderContent.find_by_sql "
   WITH interval_dates AS ( 
      SELECT date_trunc('day', date) AS date, 0 AS amount
      FROM generate_series(current_timestamp::date - '7 days'::interval, current_timestamp::date, '1 day') AS date ),
      main AS (
      SELECT COUNT(DISTINCT order_id) as orders, SUM(price * quantity) as amount, date_trunc('day', checkout_date) AS date
    FROM order_contents 
    JOIN orders ON orders.id = order_contents.order_id 
    JOIN products ON products.id = order_contents.product_id 
    WHERE checkout_date IS NOT NULL
    GROUP BY date
    ORDER BY date DESC
      ) 
      SELECT main.amount as amount, COALESCE(main.date, interval_dates.date) as date, main.orders as quantity
      FROM main FULL OUTER JOIN interval_dates ON main.date = interval_dates.date
      ORDER BY date DESC
      LIMIT #{limit}
    "
    orders.map do |o|
      [human_time(o.date), "#{o.quantity ||  0}", "$#{o.amount ? o.amount.round : 0}"]
    end
  end

  def self.largest_order_val(days=nil, n=0)
    o = Order.select('SUM(price * quantity) AS total').join_orders_with_order_contents.join_orders_with_products.where("checkout_date IS NOT NULL #{days_ago(days, n)}").group('order_id').order('total DESC').first.total
  end

  def self.join_orders_with_order_contents
    joins('JOIN order_contents ON orders.id = order_contents.order_id')
  end

  def self.join_orders_with_products
    joins('JOIN products ON products.id = product_id')
  end

  def self.days_ago(days=nil, n)
    days ? "AND checkout_date <= current_date - '#{n * days} days'::interval AND checkout_date > current_date - '#{(n + 1) * days} days'::interval " : ''
  end

  def self.by_week(limit=7)
    orders = Order.select("date_trunc('week', checkout_date) AS date, COUNT(DISTINCT order_id) AS quantity, SUM(price * quantity) AS amount").join_orders_with_order_contents.join_orders_with_products.where('checkout_date IS NOT NULL').group('date').order('date DESC').limit(limit)
    orders.map do |o|
      [human_time(o.date), o.quantity, o.amount.to_s(:currency, precision:0)]
    end
  end

  def self.human_time(time)

    case t = Time.now() - time
    when t < 1 then 'Today'
    when t < 2 then 'Yesterday'
    else time.strftime('%m/%d/%Y')
    end
  end

end
