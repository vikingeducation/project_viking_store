class Order < ActiveRecord::Base

  belongs_to :user, foreign_key: :user_id

  belongs_to :shipping_address, foreign_key: :shipping_id, class_name: "Address"
  belongs_to :billing_address, foreign_key: :billing_id, class_name: "Address"

  has_many :purchases
  has_many :products, through: :purchases


  validates :user_id, presence: true,
                      numericality: { is_integer: true }
  validates :checked_out, :inclusion => { :in => [true, false] }

  # makes any new order a placed order if shopping cart 
  # already exists
  after_validation :checked_out, :on => :create do |order|
    if User.find(order.user.id).orders.all?(&:checked_out)
      order.checked_out = false
    else
      order.checked_out = true
      order.checkout_date = Time.now
    end
  end

  # make sure only a single unplaced order
  # (shopping cart) can exist
  before_save do |order|
    unless order.checked_out
      User.find(order.user.id).orders.all?(&:checked_out)
    end
  end


  def date_placed
    checked_out && order.id ? checkout_date.strftime("%Y-%m-%d") : nil
  end

  def self.checked_out
    where.(:checked_out => true)
  end


  def self.new_orders(last_x_days = nil)
    if last_x_days
      where("checkout_date > ?", Time.now - last_x_days.days).size
    else
      where(:checked_out => true).size
    end
  end

  def self.largest_value(last_x_days = nil)
    if last_x_days
      select("SUM(purchases.quantity * products.price) AS value").
        joins("JOIN purchases ON orders.id = purchases.order_id JOIN products ON products.id = purchases.product_id").
        where("checkout_date > ?", Time.now - last_x_days.days).
        order("value DESC").
        group("orders.id").
        first.
        value
    else
      select("SUM(purchases.quantity * products.price) AS value").
      joins("JOIN purchases ON orders.id = purchases.order_id JOIN products ON products.id = purchases.product_id").
      where(:checked_out => true).
      order("value DESC").
      group("orders.id").
      first.
      value
    end
  end

  def self.orders_on(days_ago)
    where(:checkout_date => ((Time.now.midnight - days_ago.days)..(Time.now.midnight + 1.days - days_ago.days))).size
  end

  def self.daily_revenue(days_ago)
    joins("JOIN purchases ON orders.id = purchases.order_id JOIN products ON purchases.product_id = products.id").
    where(:checkout_date => ((Time.now.midnight - days_ago.days)..(Time.now.midnight + 1.days - days_ago.days))).
    sum("(purchases.quantity * products.price)")
  end

  def self.orders_in(weeks_ago)
    starting_sunday = Time.now.midnight - Time.now.wday - (7 * weeks_ago).days

    where(:checkout_date => (starting_sunday..( starting_sunday + 7.days ))).size
  end

  def self.weekly_revenue(weeks_ago)
    starting_sunday = Time.now.midnight - Time.now.wday - (7 * weeks_ago).days

    joins("JOIN purchases ON orders.id = purchases.order_id JOIN products ON purchases.product_id = products.id").
      where(:checkout_date => (starting_sunday..( starting_sunday + 7.days ))).
      sum("(purchases.quantity * products.price)")
  end
end
