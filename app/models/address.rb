class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :city
  belongs_to :state

  has_one :user_default_shipping, foreign_key: :shipping_id, class_name: 'User', dependent: :nullify
  has_one :user_default_billing, foreign_key: :shipping_id, class_name: 'User', dependent: :nullify

  has_many :ship_to_orders, foreign_key: :shipping_id, class_name: 'Order', dependent: :nullify
  has_many :bill_to_orders, foreign_key: :billing_id, class_name: 'Order', dependent: :nullify

  def city_state_zip
    "#{city.name}, #{state.name}  #{zip_code}"
  end
end
