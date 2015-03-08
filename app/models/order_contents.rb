class OrderContents < ActiveRecord::Base
  belongs_to :credit_card
  belongs_to :order
  belongs_to :product
  has_many :addresses
end
