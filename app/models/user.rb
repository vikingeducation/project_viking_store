class User < ApplicationRecord

  has_many :orders
  has_many :order_contents, through: :orders

  has_many :addresses
  has_one :billing_address, :class_name => 'Address'
  has_one :shipping_address, :class_name => 'Address'
  has_many :credit_cards


  include SharedQueries

  def self.highest_lifetime_value
    select("users.*, SUM(price * quantity) AS value").
    joins("JOIN orders ON user_id = users.id JOIN order_contents ON order_id = orders.id JOIN products ON product_id = products.id").
    where("checkout_date IS NOT NULL").
    group("users.id").
    order("SUM(price * quantity) DESC").
    limit(1)
  end


end
