class Order < ActiveRecord::Base

  belongs_to :billings, :class_name => "Address", :foreign_key => :billing_id
  belongs_to :shippings, :class_name => "Address", :foreign_key => :shipping_id
  belongs_to :user
  has_many :order_contents
  has_many :products, :through => :order_contents

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
