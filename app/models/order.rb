class Order < ActiveRecord::Base
  belongs_to :user
  has_many :order_contents
  has_many :products, :through => :order_contents

  ########
  has_many :categories, :through => :products
  #########
end
