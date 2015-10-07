class Address < ActiveRecord::Base

  validates :street_address,
                  presence: true,
                  length: { maximum: 64 }

  validates :zip_code,
                  presence: true,
                  numericality: { only_integer: true },
                  length: { is: 5 }

  validates :city_id,
                 :state_id,
                  numericality: { only_integer: true },
                  presence: true


  belongs_to :user,
   foreign_key: :user_id

  belongs_to :state,
   foreign_key: :state_id

  belongs_to :city,
   foreign_key: :city_id


  has_many :order_billed,
      :class_name => "Order",
      foreign_key: :billing_id

  has_many :order_shipped,
      :class_name => "Order",
      foreign_key: :shipping_id

end
