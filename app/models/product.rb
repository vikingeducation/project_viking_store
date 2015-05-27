class Product < ActiveRecord::Base

  has_many :order_contents, class_name: "OrderContents"
  has_many :orders, through: :order_contents
  has_many :users, through: :orders
  belongs_to :category

  def self.total
    count
  end
end
