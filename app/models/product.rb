class Product < ActiveRecord::Base

  has_many :order_contents, :class_name => "OrderContents"
  has_many :orders, :through => :order_contents
  belongs_to :category

  def self.new_products(time_period)
    Product.where("created_at > ?", time_period).count
  end

  def self.in_the_last_seven_days 
    self.new_products(7.days.ago)
  end

  def self.in_the_last_thirty_days
    self.new_products(30.days.ago)
  end
end
