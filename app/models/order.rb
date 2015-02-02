class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :billing, :class_name => "Address"
  belongs_to :shipping, :class_name => "Address"
  belongs_to :credit_card

  has_many :purchases, :dependent => :destroy
  has_many :products, through: :purchases
  has_many :categories, through: :products

  validates :user_id,
            :presence => true
  validates_inclusion_of :checked_out, :in => [true, false]

  def value
    products.sum("quantity * price")
  end

  def quantity
    purchases.sum(:quantity)
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
    starting_monday = Time.now.beginning_of_week

    where(:checkout_date => (starting_monday..(starting_monday+7.days))).size
  end

  def self.weekly_revenue(weeks_ago)
    starting_monday = Time.now.beginning_of_week

    joins("JOIN purchases ON orders.id = purchases.order_id JOIN products ON purchases.product_id = products.id").
    where(:checkout_date => (starting_monday..(starting_monday+7.days))).
    sum("(purchases.quantity * products.price)")
  end
end
