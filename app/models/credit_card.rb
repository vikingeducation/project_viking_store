class CreditCard < ActiveRecord::Base
  belongs_to :user

  has_many :billed_orders, :class_name => 'Order', :foreign_key => :billing_card_id
end
