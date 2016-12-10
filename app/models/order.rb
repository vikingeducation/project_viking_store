class Order < ApplicationRecord
  belongs_to :address
  belongs_to :user
  belongs_to :credit_card
  has_many :order_contents
end
