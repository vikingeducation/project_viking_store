class Order < ActiveRecord::Base

  belongs_to :user#, foreign_key: :user_id

  belongs_to :billed_address,
        foreign_key: :billing_id,
        :class_name => "Address"

  belongs_to :shipped_address,
        foreign_key: :shipping_id,
        :class_name => "Address"

  has_many :order_contents
  has_many :products, through: :order_contents

  belongs_to :credit_card

  validates :user_id,
            presence: true,
            numericality: { is_integer: true }

  def self.number
    return Order.
    all.
    count
  end

  def self.cart
    return self.find_by_sql(
      "
      SELECT *  FROM orders
      WHERE
      checkout_date IS NULL
      "
      )
  end

  def self.checked_order
    return self.find_by_sql(
      "
      SELECT *  FROM orders
      WHERE
      checkout_date IS NOT NULL
      "
      )

  end

  def self.number_in(days)
    self.where("checkout_date > ?",Time.now - days.day).
    count
  end

  def self.max(days)
    select("orders.id, SUM(order_contents.quantity * products.price) AS value").
      joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date > ?", days.days.ago).
      order("value DESC").
      group("orders.id").
      first.
      value
  end

  def self.total(num_days)
     self.joins("JOIN order_contents ON orders.id = order_id").
     joins("JOIN products ON products.id = product_id").
     select("*").
     where("checkout_date > ?",Time.now - num_days.day).
     sum("price * quantity")
  end
end
