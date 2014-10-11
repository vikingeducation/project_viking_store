class Address < ActiveRecord::Base

  belongs_to :user
  belongs_to :state
  belongs_to :city

  has_many :orders_billing_here,
           class_name: "Order",
           foreign_key: :billing_id

  has_many :orders_shipping_here,
           class_name: "Order",
           foreign_key: :shipping_id

  has_one :user_shipping_here,
           class_name: "User",
           foreign_key: :billing_id

  has_one :user_billing_here,
           class_name: "User",
           foreign_key: :shipping_id


  validates :street_address, :secondary_address,
                            length: { maximum: 128 },
                            presence: true

  validates :zip_code, numericality: { only_integer: true },
                       presence: true,
                       length: { is: 5 }

  validates :city_id, :state_id, :user_id,
                      numericality: { only_integer: true },
                      presence: true
end
