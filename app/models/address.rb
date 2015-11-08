class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :city
  belongs_to :state
  has_many :billed_orders, foreign_key: :billing_id, class_name: "Order"
  has_many :shipped_orders, foreign_key: :shipping_id, class_name: "Order"

  def orders_count
    Order.select("COUNT(*) as num_orders").
    where( "shipping_id = :ship OR billing_id = :bill", { ship: id, bill: id } ).
    to_a.first.num_orders
  end

end
