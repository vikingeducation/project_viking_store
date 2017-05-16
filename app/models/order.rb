class Order < ApplicationRecord
  has_many :order_contents,
           :dependent => :destroy
  has_many :products,
           :through => :order_contents
  has_many :categories,
           :through => :products,
           :source => :category
  belongs_to :user

  def self.value_per_order
    select(
      "orders.id, orders.created_at, SUM(products.price) AS value,
       orders.checkout_date"
    ).joins(:order_contents).joins(:products).group(
    "orders.id")
  end

  def self.average_value
    joins(
      "JOIN order_contents oc ON oc.order_id = orders.id"
    ).joins(
      "JOIN products p ON oc.product_id = p.id"
    ).where("orders.checkout_date IS NOT NULL").average("p.price")
  end

  def self.average_value_since(d)
    joins(
      "JOIN order_contents oc ON oc.order_id = orders.id"
    ).joins(
      "JOIN products p ON oc.product_id = p.id"
    ).where(
      "orders.checkout_date IS NOT NULL AND oc.created_at > ?", d
    ).average("p.price")
  end

  def self.highest_average_value
    select(
      "AVG(p.price) AS quantity, u.first_name || ' ' || u.last_name AS customer_name"
    ).joins(
      "JOIN users u ON u.id = orders.user_id"
    ).joins(
      "JOIN order_contents oc ON oc.order_id = orders.id"
    ).joins(
      "JOIN products p ON oc.product_id = p.id"
    ).where("checkout_date IS NOT NULL").group(:customer_name).order(
      "1 DESC"
    ).limit(1).first
  end

  def self.highest_lifetime_value
    select(
      "SUM(p.price) AS quantity, u.first_name || ' ' || u.last_name AS customer_name"
    ).joins(
      "JOIN users u ON u.id = orders.user_id"
    ).joins(
      "JOIN order_contents oc ON oc.order_id = orders.id"
    ).joins(
      "JOIN products p ON oc.product_id = p.id"
    ).where("checkout_date IS NOT NULL").group(:customer_name).order(
      "1 DESC"
    ).limit(1).first
  end

  def self.highest_value
    select(
      "SUM(p.price) AS quantity,
       u.first_name || ' ' || u.last_name AS customer_name,
       orders.id AS order_id"
    ).joins(
      "JOIN users u ON u.id = orders.user_id"
    ).joins(
      "JOIN order_contents oc ON oc.order_id = orders.id"
    ).joins(
      "JOIN products p ON oc.product_id = p.id"
    ).where("checkout_date IS NOT NULL").group("2, 3").order(
      "1 DESC"
    ).limit(1).first
  end

  def self.highest_value_since(d)
    r = select(
      "SUM(p.price) AS quantity,
       u.first_name || ' ' || u.last_name AS customer_name,
       orders.id AS order_id"
    ).joins(
      "JOIN users u ON u.id = orders.user_id"
    ).joins(
      "JOIN order_contents oc ON oc.order_id = orders.id"
    ).joins(
      "JOIN products p ON oc.product_id = p.id"
    ).where(
      "checkout_date IS NOT NULL AND oc.created_at > ?", d
    ).group("2, 3").order(
      "1 DESC"
    ).limit(1).first
    if r
      {:customer_name => r.customer_name,
       :quantity => r.quantity}
    else
      {:customer_name => "No result",
       :quantity => 0}
    end
  end

  def self.most_orders_placed
    select(
      "COUNT(orders.user_id) AS quantity,
       u.first_name || ' ' || u.last_name AS customer_name"
    ).joins(
      "JOIN users u ON u.id = orders.user_id"
    ).joins(
      "JOIN order_contents oc ON oc.order_id = orders.id"
    ).joins(
      "JOIN products p ON oc.product_id = p.id"
    ).where("checkout_date IS NOT NULL").group(:customer_name).order(
      "1 DESC"
    ).limit(1).first
  end

end
