class Product < ActiveRecord::Base
  include Recentable
  has_many :order_contents
  has_many :orders, through: :order_contents

  belongs_to :category
end
