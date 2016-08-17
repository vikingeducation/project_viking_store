class Order < ActiveRecord::Base
  has_many :order_contents
  has_many :products, through: :order_contents
  belongs_to :user

  belongs_to :shipping_address,
             class_name: "Address", 
             foreign_key: :shipping_id

  belongs_to :billing_address,
              class_name: "Address",
              foreign_key: :billing_id

  belongs_to :credit_card

  def last_four_card_digits
    credit_card[-4..-1]
  end

  def total_value
    value = order_contents.select("SUM(quantity * price) AS total_value")
                  .joins("JOIN products ON product_id=products.id")
                  .group("order_contents.id")

    value.empty? ? nil : value.first.total_value 
  end

  def status
    checkout_date ? "PLACED" : "UNPLACED"
  end

  def self.created_last_seven_days
    Order.where('created_at > ?', Time.now - 7.days)
  end

  def self.created_last_thirty_days
    Order.where('created_at > ?', Time.now - 30.days)
  end
end
