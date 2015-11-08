class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :city
  belongs_to :state
  accepts_nested_attributes_for :city
  has_many :billed_orders, foreign_key: :billing_id, class_name: "Order"
  has_many :shipped_orders, foreign_key: :shipping_id, class_name: "Order"

  validates_associated :city
  validates :street_address, :zip_code, length: { in: 1..64 }
  validate :validate_state_id
  validate :user_id

  def orders_count
    Order.select("COUNT(*) as num_orders").
    where( "shipping_id = :ship OR billing_id = :bill", { ship: id, bill: id } ).
    to_a.first.num_orders
  end


  private


  def validate_state_id
    errors.add(:state_id, "is invalid") unless State.exists?(self.state_id)
  end


  def validate_user_id
    errors.add(:user_id, "is invalid") unless User.exists?(self.user_id)
  end

end
