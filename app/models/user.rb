class User < ActiveRecord::Base

  has_many :addresses, dependent: :destroy
  has_many :orders
  has_one :credit_card, dependent: :destroy


  has_many :order_contents, :through => :orders
  has_many :products, :through => :order_contents, source: :product

  validates :first_name, length: { in: 1..64 }
  validates :last_name, length: { in: 1..64 }
  validates :email, email: true

  def full_name
    "#{self.first_name} #{self.last_name}"
  end



  def billing_address
    self.addresses.find(self.billing_id)
  end

  def shipping_address
    self.addresses.find(self.shipping_id)
  end

  def self.total
    User.all.count
  end

  def self.new_users(n)
    User.all.where("created_at BETWEEN (NOW() - INTERVAL '#{n} days') AND NOW()").count
  end

  def self.highest_single_order
    User.select("SUM(oc.quantity * p.price) AS order_value,
      concat(u.first_name, ' ', u.last_name) AS user")
        .joins("AS u JOIN orders o ON o.user_id = u.id")
        .joins("JOIN order_contents oc ON o.id = oc.order_id")
        .joins("JOIN products p ON p.id = oc.product_id")
        .where("o.checkout_date IS NOT null")
        .group("u.id, o.id")
        .order("order_value DESC")
        .limit(1)
  end


  def self.highest_lifetime
    User.select("SUM(oc.quantity * p.price) AS lifetime_total,
       concat(u.first_name, ' ', u.last_name) AS user")
        .joins("AS u JOIN orders o ON o.user_id = u.id")
        .joins("JOIN order_contents oc ON o.id = oc.order_id")
        .joins("JOIN products p ON p.id = oc.product_id")
        .where("o.checkout_date IS NOT null")
        .group("u.id")
        .order("lifetime_total DESC")
        .limit(1)
  end

  def self.highest_average
    User.select("ROUND(AVG(oc.quantity * p.price),2) AS avg_order_value, concat(u.first_name, ' ', u.last_name) AS user")
      .joins("AS u JOIN orders o ON o.user_id=u.id")
      .joins("JOIN order_contents oc ON o.id = oc.order_id")
      .joins("JOIN products p ON p.id = oc.product_id")
      .where("o.checkout_date IS NOT null")
      .group("u.id")
      .order("avg_order_value DESC")
      .limit(1)
  end

  def self.most_ordered
    User.select("COUNT(o.id) AS order_count, concat(u.first_name, ' ', u.last_name) AS user")
      .joins("AS u JOIN orders o ON o.user_id=u.id")
      .group("u.id")
      .order("order_count DESC")
      .limit(1)
  end


end
