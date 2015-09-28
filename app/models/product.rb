class Product < ActiveRecord::Base
  has_many :order_contents
  has_many :orders, :through => :order_contents
  belongs_to :category

  validates :name,
            :presence => true

  validates :sku,
            :presence => true,
            :uniqueness => true

  validates :description,
            :presence => true,
            :length => {
              :minimum => 8
            }

  validates :price,
            :presence => true,
            :numericality => true,
            :format => /\A[0-9]{1,4}(\.[0-9]{1,2})?\z/

  validates :category,
            :presence => true


  def carts
    orders.where('checkout_date IS NULL').to_a
  end

  def placed_orders
    orders.where('checkout_date IS NOT NULL').to_a
  end

  def units_sold
    result = order_contents.select('SUM(quantity) AS sum_quantity')
    .to_a
    result.first.sum_quantity || 0
  end

  # Returns all the products
  # with a created_at date after the given date
  def self.count_since(date)
    Product.where('created_at > ?', date).count
  end
end
