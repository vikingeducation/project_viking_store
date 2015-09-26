class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :shipping, :class_name => 'Address'
  belongs_to :billing, :class_name => 'Address'
  belongs_to :credit_card
end
