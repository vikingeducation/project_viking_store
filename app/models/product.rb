class Product < ActiveRecord::Base
  include Recentable
  has_many :order_contents
  belongs_to :Category
end
