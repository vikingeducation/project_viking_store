class Product < ActiveRecord::Base
  belongs_to :category
  has_many :order_contents
  has_many :orders, through: :order_contents

  validates :name, :description, :sku, :category_id, :price, :presence => true
  validates :price, :numericality => { :less_than_or_equal_to => 10_000 }

  def self.created_last_seven_days
    Product.where('created_at > ?', Time.now - 7.days)
  end

  def self.created_last_thirty_days
    Product.where('created_at > ?', Time.now - 30.days)
  end
end
