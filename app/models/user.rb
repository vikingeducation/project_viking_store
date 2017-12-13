class User < ApplicationRecord

  has_many :orders

  has_many :purchased_products, through: :orders, source: :products
  has_many :products, through: :orders, source: :products

  has_many :order_contents, through: :orders

  has_many :addresses, dependent: :destroy
  belongs_to :billing_address,
             class_name: 'Address',
             foreign_key: :billing_id

  belongs_to :shipping_address,
             class_name: 'Address',
             foreign_key: :shipping_id

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

  def name
    "#{first_name} #{last_name}"
  end

  def city
    billing_address.city.name if billing_address
  end

  def state
    billing_address.state.abbreviation if shipping_address
  end

  def orders_count
    orders.where('checkout_date IS NOT NULL').count
  end

  def purchased_orders
    orders.where('checkout_date IS NOT NULL').order('checkout_date DESC')
  end

  def last_order_date
    unless orders.empty?
      o = orders.where('checkout_date IS NOT NULL').order('checkout_date DESC')
      o.first.checkout_date.to_date unless o.empty?
    end
  end

  def cart?
    orders.where('checkout_date IS NULL').count > 0
  end

end
