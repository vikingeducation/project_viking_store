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
end
