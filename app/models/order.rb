class Order < ActiveRecord::Base
  
  belongs_to :user
  has_many :order_contents
  has_many :products, through: :order_contents

  has_many :products, through: :order_contents,
            source: :product

  belongs_to :billing_add,
            class_name: "Address",
            foreign_key: :billing_id

  belongs_to :shipping_add,
            class_name: "Address",
            foreign_key: :shipping_id

  belongs_to :credit_card

  def total_value
    order_contents.inject(0) {|sum, order| sum += order.total }
  end

  def last_four
    credit_card.card_number[-4..-1] unless credit_card.nil?
  end

  def self.total(days=nil)
    if days.nil?
      self.all.count
    else
      self.all.where("checkout_date > CURRENT_DATE - interval '#{days} day' ").count
    end
  end

  def self.order_by_day(days)
    subquery = self.select("COUNT(orders.id) AS ord, SUM(products.price * order_contents.quantity) AS val, orders.checkout_date").joins("JOIN order_contents ON order_id = orders.id").joins("JOIN products ON order_contents.product_id = products.id").where("checkout_date IS NOT NULL AND checkout_date BETWEEN CURRENT_DATE - #{days} AND CURRENT_DATE - #{days-1}").group("orders.checkout_date")
    from(subquery).select("SUM(ord) as total, SUM(val) as value")
  end

  def self.order_by_week(weeks)
    subquery = self.select("COUNT(orders.id) AS ord, SUM(products.price * order_contents.quantity) AS val, orders.checkout_date").joins("JOIN order_contents ON order_id = orders.id").joins("JOIN products ON order_contents.product_id = products.id").where("checkout_date IS NOT NULL AND checkout_date BETWEEN CURRENT_DATE - interval '#{weeks} weeks' AND CURRENT_DATE - interval '#{weeks-1} weeks' ").group("orders.checkout_date")
    from(subquery).select("SUM(ord) as total, SUM(val) as value")
  end



end
