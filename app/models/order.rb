# From the schema
# create_table "orders", force: :cascade do |t|
  # t.datetime "checkout_date"
  # t.integer  "user_id",        null: false
  # t.integer  "shipping_id"
  # t.integer  "billing_id"
  # t.datetime "created_at"
  # t.datetime "updated_at"
  # t.integer  "credit_card_id"
# end

class Order < ActiveRecord::Base

  has_many :order_contents, dependent: :destroy
  has_many :products,   through: :order_contents
  has_many :categories, through: :products,
                        source: :category

  belongs_to :shipping_address, class_name: "Address",
                                foreign_key: :shipping_id
  belongs_to :billing_address,  class_name: "Address",
                                foreign_key: :billing_id

  belongs_to :user

  accepts_nested_attributes_for :order_contents, reject_if: proc { |attributes| attributes['product_id'].blank? }

  def placed?
    !!checkout_date
  end

  def cart?
    !checkout_date
  end

  def value
    products.sum('price * quantity')
  end

  def self.recent(num_days = 7)
    Order.processed.where("orders.checkout_date >= ? ", num_days.days.ago.beginning_of_day)
  end

  def self.total_revenue
    Order.processed.joins(:products).sum('price * quantity')

    # Old query for reference
    # Order.processed.joins("JOIN order_contents ON order_id = orders.id JOIN products ON product_id = products.id ").sum("quantity * price").to_f
  end

  def self.processed
    Order.where("checkout_date IS NOT NULL")
  end

  def self.top_states
    Order.processed.joins(:billing_address).count(:state).order(:state, :desc).limit(3)

    # Order.processed.select("states.name").
    #   joins("JOIN addresses ON addresses.id = orders.billing_id").
    #   joins("JOIN states ON states.id = addresses.state_id").
    #   group("states.name").
    #   order("COUNT(states.name) DESC").
    #   limit(3)
    #   .count
  end

  def self.average_value
    # Order.joins(:products).average('price * quantity')

    Order.processed.select("order_total").from(Order.order_totals, :orders).average("order_total")
  end

  def self.largest_value
    Order.select("order_total").from(Order.order_totals, :orders).maximum("order_total")
  end

  def self.order_totals
    Order.processed.select("orders.*, SUM(price * quantity) AS order_total").joins(:products).group("orders.id")
  end

  def self.orders_by_day
    Order.join_days.select("day, COALESCE(SUM(order_total), 0) as sum, COUNT(order_total) as quantity").
      from(Order.order_totals, :orders).
      group("day").
      where("day < ?", Date.today + 1).
      order("day DESC")
  end

  def self.orders_by_week
    Order.join_weeks.select("week, COALESCE(SUM(order_total), 0) as SUM, COUNT(order_total) as quantity").
      from(Order.order_totals, :orders).
      group("week").
      order("week DESC")
  end

  def self.join_days
    Order.joins "RIGHT JOIN GENERATE_SERIES((SELECT DATE(MIN(checkout_date)) FROM orders), CURRENT_DATE, '1 DAY'::INTERVAL) day ON DATE(orders.checkout_date) = day"
  end

  def self.join_weeks
    Order.joins "RIGHT JOIN GENERATE_SERIES((SELECT DATE(DATE_TRUNC('WEEK', MIN(checkout_date))) FROM orders), CURRENT_DATE, '1 WEEK'::INTERVAL) week ON DATE(DATE_TRUNC('WEEK', orders.checkout_date)) = week"
  end
end
