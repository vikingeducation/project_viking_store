class Product < ActiveRecord::Base

  belongs_to :category

  has_many :order_contents, dependent: :destroy
  has_many :orders, through: :order_contents

  validates :name, :price, :sku, presence: true
  validates :price, numericality: { less_than: 10001, greater_than: 0 }
  validates :sku, length: { is: 13 }
  validate :validate_category_id


  def self.total_listed(period = nil)
    total = Product.select("COUNT(*) AS t")
    if period
      total = total.where( "created_at BETWEEN :start AND :finish",
                          { start: DateTime.now - period, finish: DateTime.now } )
    end
    total.to_a.first.t
  end


  # instance methods
  def order_stats
    o = orders
    carts = o.where("checkout_date IS NULL").count
    completed_orders = ( o.count - carts )
    {carts: carts, orders: completed_orders}
  end


  def price=(price_str)
    write_attribute(:price, price_str.tr('$ ,', ''))
  end


  private


  def validate_category_id
    errors.add(:category_id, "is invalid") unless Category.exists?(self.category_id)
  end

end
