class Order < ActiveRecord::Base

  # You wouldn't destroy any addresses or nullify any address stuff when you're deleting an order.
  belongs_to :billing_address, :class_name => "Address", :foreign_key => :billing_id
  belongs_to :shipping_address, :class_name => "Address", :foreign_key => :shipping_id
  # You wouldn't destroy an user or nullify anything re user
  belongs_to :user
  # If you deleted an order there's no need to keep any join table items which has this order_id in it. Destroy!
  has_many :order_contents, :dependent => :destroy
  # You wouldn't destroy any products because you deleted an order and no need to null anything cos you're destroying orphans in the order_contents join table.
  has_many :products, :through => :order_contents

  has_many :categories, :through => :products

  # scope examples...
  # scope :checked_out, lambda { where("checkout_date IS NOT NULL") }
  # scope :not_checked_out, lambda { where("checkout_date IS NULL") }

  def self.created_since_days_ago(number)
    Order.where('checkout_date >= ?', number.days.ago).count
  end

  # I want to get the last 7 days worth of results. Erik said specifically, Specifically, make sure your daily time series does NOT require a separate query for each day! I'm guessing he's saying send one query that will grab everything at once. 

  def self.total_orders_for_each_of_the_last_seven_days
    # Making an array with 7 arrays in it
    dates_and_totals = Array.new(7) {Array.new}
    # Want to put in seven time stamps from today backwards
    7.times do |n|
      dates_and_totals[n] << Time.now - n.day
    end
    # What's the most basic way I can think of doing this, it would be to construct 
    Order.where('checkout_date >= ?', Time.now - 1.day).count
  end

  def shipping_street_address
    self.shipping_address ? self.shipping_address.street_address : "n/a"
  end

  def shipping_city_name
    self.shipping_address ? self.shipping_address.city.name : "n/a"
  end

  def shipping_state_name
    self.shipping_address ? self.shipping_address.state.name : "n/a"
  end

  # We want to know if an order has been checked_out yet or not.
  # Can do this in the orders table using a ternary expression.
  # If an order has a checkout_date, return "PLACED", else return "UNPLACED"
  def status(order_id)
    Order.find(order_id).checkout_date ? "PLACED" : "UNPLACED"
  end

  # Finding out the value of an order. 
  # Doing this by joining up the order_contents table and products table.
  # Only getting those rows that have our desired order_id.
  # first multiplying the quantity of a product in that order by the price of that product.
  # next getting the sum of all the totals and accessing that by getting the first value (the only value) and the calling the column name on it (sum)
  def value(order_id)
    OrderContent.find_by_sql("SELECT SUM(order_contents.quantity * products.price)
                              FROM order_contents
                              JOIN products
                              ON order_contents.product_id = products.id
                              WHERE order_contents.order_id = #{order_id}").first.sum
  end
end
