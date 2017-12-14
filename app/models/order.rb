class Order < ApplicationRecord

  belongs_to :user

  belongs_to :billing_address, :class_name => 'Address', foreign_key: :billing_id
  belongs_to :shipping_address, :class_name => 'Address', foreign_key: :shipping_id
  belongs_to :credit_card, :class_name => 'CreditCard', foreign_key: :credit_card_id

  has_many :order_contents, dependent: :destroy
  has_many :contents, foreign_key: 'order_id', class_name: 'OrderContent'

  has_many :products, through: :order_contents
  has_many :categories, through: :products, source: :category

  include SharedQueries


  def self.last_n_days(n)
    past = Date.today - n.days
    where("checkout_date > ?", past)
  end

  def self.total_revenue
    where("checkout_date IS NOT NULL").includes(:products).pluck(:price).reduce(&:+).to_f
  end

  def self.highest_value
      select("orders.id, textcat(textcat(users.first_name, ' '), users.last_name) AS name, SUM(order_contents.quantity * products.price) AS value").
      joins("JOIN users ON orders.user_id = users.id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date IS NOT NULL").
      order("value DESC").
      group("orders.id, textcat(textcat(users.first_name, ' '), users.last_name)").
      limit(1).first
  end

  def value
    products.sum("quantity * price")
  end

  def placed?
    checkout_date != nil
  end

end
