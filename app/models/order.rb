class Order < ActiveRecord::Base
  has_many :items, :class_name => 'OrderContent'
  has_many :products, :through => :items
  belongs_to :user
  belongs_to :shipping, :class_name => 'Address'
  belongs_to :billing, :class_name => 'Address'
  belongs_to :credit_card
  has_many :categories, :through => :products

  validates :user,
            :presence => true

  validates :shipping,
            :presence => true

  validates :billing,
            :presence => true

  # validates :credit_card,
  #           :presence => true

  before_save :one_cart_per_user
  before_destroy :dissociate

  SUM_QUANTITY_PRICE = 'SUM(order_contents.quantity * products.price) AS amount'

  # --------------------------------
  # Public Instance Methods
  # --------------------------------

  # Before save callback
  # returns false if this order is not placed,
  # the associated user already has a cart,
  # and this order's ID is the same as the user's cart ID
  def one_cart_per_user
    if user.has_cart? && checkout_date == nil && user.cart.id != id
      errors.add(:base, 'A user can only have one shopping cart')
      false
    end
  end

  # Before destroy callback
  # destroys dependent order_content rows
  # returns false if checkout_date is not nil
  def dissociate
    if checkout_date
      false
    else
      items.destroy_all
    end
  end

  # Creates order_content rows for this order
  # tries to save all order_contents in
  # a transaction
  # rescues error and appends message to
  # order base errors
  # returns false if transaction fails
  def create_items(attrs)
    success = true
    begin
      Order.transaction do
        attrs.each do |a|
          order_content = OrderContent.new(a)
          order_content.save!
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      errors[:base] << e
      success = false
    end
    success
  end

  # Updates order_content rows for this order
  # tries to update all order_contents in
  # a transaction
  # destroys the row if quantity is 0
  # rescues error and appends message to
  # order base errors
  # returns false if transaction fails
  def update_items(attrs)
    success = true
    begin
      Order.transaction do
        attrs.each do |a|
          order_content = OrderContent.find(a[:id])
          if a[:quantity].to_i > 0
            order_content.update!(a)
          else
            order_content.destroy!
          end
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      errors[:base] << e
      success = false
    end
    success
  end

  # Returns the revenue for this order
  def revenue
    result = Order.join_order_contents_products(SUM_QUANTITY_PRICE)
      .where('order_contents.order_id = ?', id)
      .limit(1)
      .to_a
      .first
    result ? result.amount.to_f : 0
  end

  # --------------------------------
  # Public Class Methods
  # --------------------------------

  # 
  # Returns all orders without a
  # checkout date
  def self.carts
    Order.where('checkout_date IS NULL')
  end

  # 
  # Returns all orders with a
  # checkout date
  def self.placed_orders
    Order.where('checkout_date IS NOT NULL')
  end

  # Returns the order count of orders
  # with a checkout_date after the given date
  def self.count_since(date)
    Order.where('checkout_date >= ?', date.to_date).count
  end

  # Returns the total revenue for all orders
  def self.revenue
    result = Order.join_order_contents_products(SUM_QUANTITY_PRICE)
      .limit(1)
      .to_a
      .first
    result ? result.amount.to_f : 0
  end

  # Returns the total revenue for all orders
  # with a checkout_date after the given date
  def self.revenue_since(date)
    result = Order.join_order_contents_products(SUM_QUANTITY_PRICE)
      .where('orders.checkout_date >= ?', date.to_date)
      .limit(1)
      .to_a
      .first
    result ? result.amount.to_f : 0
  end

  # Returns the average revenue for all orders
  def self.avg_revenue
    count = Order.count
    count == 0 ? 0 : Order.revenue / count
  end

  # Returns the average revenue for all orders
  # with a checkout_date after the given date
  def self.avg_revenue_since(date)
    count = Order.count_since(date)
    count == 0 ? 0 : Order.revenue_since(date) / count
  end

  # Returns the order with the highest revenue
  def self.with_max_revenue
    result = Order.prepare_max_revenue
      .to_a
      .first
    Order.result_order_id_or_new(result)
  end

  # Returns the order with the highest revenue
  # with a checkout_date after the given date
  def self.with_max_revenue_since(date)
    result = Order.prepare_max_revenue
      .where('orders.checkout_date >= ?', date.to_date)
      .to_a
      .first
    Order.result_order_id_or_new(result)
  end


  private

  # --------------------------------
  # Private Class Methods
  # --------------------------------

  # Wraps reusable find order by id or instantiate new order
  def self.result_order_id_or_new(result)
    order = Order.find(result.order_id) if result
    order || Order.new
  end

  # Wraps reusable join on orders, order_contents and products
  def self.join_order_contents_products(sql='*')
    OrderContent.select(sql)
      .joins(:product)
      .joins(:order)
  end

  # Wraps reusable time series generation SQL string
  # with optional start and end dates
  def self.generate_series(type, start_date=nil, end_date=nil)
    do_select = start_date.nil?
    start_date = start_date ? "DATE('#{start_date.to_date}')" : 'MIN(orders.checkout_date)'
    start_date = "DATE_TRUNC('#{type.singularize.upcase}', #{start_date})" unless type == 'day'
    start_date = do_select ? "(SELECT DATE(#{start_date}) FROM orders)" : start_date
    end_date = end_date ? "'#{end_date.to_date}'" : "CURRENT_DATE"
    "GENERATE_SERIES(#{start_date}, #{end_date}, '1 #{type.singularize.upcase}'::INTERVAL) #{type.pluralize}"
  end

  # Wraps reusable time series join date
  # for multiple date interval types
  def self.time_series_join_date(type)
    type == 'day' ? 'DATE(orders.checkout_date)' : "DATE(DATE_TRUNC('#{type.singularize.upcase}', orders.checkout_date))"
  end

  # Wraps reusable time series revenue
  # for multiple date interval types
  # and optional date range
  def self.join_time_series_revenue(type, start_date=nil, end_date=nil)
    select_statement = [
      "DATE(#{type.pluralize}) AS #{type.singularize}",
      'COALESCE(SUM(order_contents.quantity * products.price), 0) AS amount'
    ].join(',')

    from_statement = Order.generate_series(type, start_date, end_date)

    OrderContent.select(select_statement)
      .from(from_statement)
      .joins("LEFT JOIN orders ON #{Order.time_series_join_date(type)} = #{type.pluralize}")
      .joins('LEFT JOIN order_contents ON orders.id = order_contents.order_id')
      .joins('LEFT JOIN products ON products.id = order_contents.product_id')
      .group("#{type.pluralize}")
      .order("#{type.pluralize} DESC")
  end

  # Wraps reusable time series count
  # for multiple date interval types
  # and optional date range
  def self.join_time_series_count(type, start_date=nil, end_date=nil)
    select_statement = [
      "DATE(#{type.pluralize}) AS #{type.singularize}",
      'COUNT(orders.*) AS num_orders'
    ].join(',')

    from_statement = Order.generate_series(type, start_date, end_date)

    OrderContent.select(select_statement)
      .from(from_statement)
      .joins("LEFT JOIN orders ON #{Order.time_series_join_date(type)} = #{type.pluralize}")
      .group("#{type.pluralize}")
      .order("#{type.pluralize} DESC")
  end

  # Wraps reusable query to find max revenue
  def self.prepare_max_revenue
    sql = [
      'orders.id AS order_id',
      SUM_QUANTITY_PRICE
    ].join(',')

    Order.join_order_contents_products(sql)
      .group('orders.id')
      .limit(1)
      .order('amount DESC')
  end
end

# --------------------------------
# Dynamic Time Series Methods
# --------------------------------

attributes = ['revenue', 'count']
time_intervals = ['day', 'week', 'month', 'year']

attributes.each do |attribute|
  time_intervals.each do |time_interval|
    Order.class_eval %Q{
      def self.#{attribute}_by_#{time_interval}
        Order.join_time_series_#{attribute}('#{time_interval}')
          .to_a
      end

      def self.#{attribute}_for_#{time_interval}(date)
        Order.join_time_series_#{attribute}('#{time_interval}')
          .where('#{time_interval}s = ?', date.to_date)
          .to_a
      end

      def self.#{attribute}_for_#{time_interval}_range(start_date, end_date)
        Order.join_time_series_#{attribute}('#{time_interval}', start_date, end_date)
          .to_a
      end
    }
  end
end













