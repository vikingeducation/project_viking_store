class Product < ActiveRecord::Base
  include Recentable
  belongs_to :category
  has_many :order_contents
end
