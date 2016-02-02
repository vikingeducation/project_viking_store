class Product < ActiveRecord::Base
  include Recentable
  has_many :order_contents
end
