class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :city
  belongs_to :state

  has_one :user_default_shipping, foreign_key: :shipping_id, class_name: 'User'
  has_one :user_default_billing, foreign_key: :shipping_id, class_name: 'User'
end
