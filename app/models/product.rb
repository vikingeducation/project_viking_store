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

  # --------------------------------
  # Public Instance Methods
  # --------------------------------

  # Returns all orders with this product
  # without a checkout date
  def carts
    carts_relation.to_a
  end

  # Returns all orders with this product
  # with a checkout date
  def placed_orders
    placed_orders_relation.to_a
  end

  # Returns the number of units this product
  # has sold
  def units_sold
    result = order_contents.select('SUM(quantity) AS sum_quantity')
      .where('order_id IN (?)', placed_orders_relation.ids)
      .to_a
    result.first.sum_quantity || 0
  end

  # --------------------------------
  # Public Class Methods
  # --------------------------------

  # Returns all the products
  # with a created_at date after the given date
  def self.count_since(date)
    Product.where('created_at >= ?', date.to_date).count
  end


  private

  # --------------------------------
  # Private Instance Methods
  # --------------------------------

  # Returns the relation collection for carts
  def carts_relation
    orders.where('checkout_date IS NULL')
  end

  # Returns the relation collection for placed orders
  def placed_orders_relation
    orders.where('checkout_date IS NOT NULL')
  end
end
