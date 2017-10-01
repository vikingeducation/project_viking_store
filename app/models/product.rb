class Product < ApplicationRecord

  belongs_to :user
  belongs_to :category

  has_many :order_contents
  has_many :orders, :through => :order_contents
  

  validates :price,
            :numericality => { :less_than_or_equal_to => 10_000 }
  
  def self.product_count
    Product.count 
  end

  def self.product_created(days)
    Product.where('created_at > ?',(Time.now - days.days)).count 
  end

end
