class Address < ActiveRecord::Base
  before_destroy :remove_default

  belongs_to :user
  belongs_to :city, autosave: true
  belongs_to :state
  accepts_nested_attributes_for :city
  has_many :billed_orders, foreign_key: :billing_id, class_name: "Order", 
                           dependent: :nullify
  has_many :shipped_orders, foreign_key: :shipping_id, class_name: "Order", 
                            dependent: :nullify

  validates_associated :city
  validates :street_address, :zip_code, length: { in: 1..64 }
  validate :validate_state_id
  validate :user_id
  

  def orders_count
    Order.select("COUNT(*) as num_orders").
    where( "shipping_id = :ship OR billing_id = :bill", { ship: id, bill: id } ).
    to_a.first.num_orders
  end


  def autosave_associated_records_for_city
    if new_city = City.find_by_name(city.name)
      self.city = new_city
    else
      city.save!
      self.city = city
    end
  end


  private


  def validate_state_id
    errors.add(:state_id, "is invalid") unless State.exists?(self.state_id)
  end


  def validate_user_id
    errors.add(:user_id, "is invalid") unless User.exists?(self.user_id)
  end


  def remove_default
    user.default_shipping_address = nil if user.default_shipping_address == self
    user.default_billing_address = nil if user.default_billing_address == self
  end

end
