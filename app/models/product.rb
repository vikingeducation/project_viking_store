class Product < ActiveRecord::Base
  include Recentable
  belongs_to :category, inverse_of: :products
  has_many :order_contents
end
