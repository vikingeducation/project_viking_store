class Product < ApplicationRecord

  belongs_to :category
  has_many :order_contents
  has_many :orders, :through => :order_contents

  validates :price,
            :presence => true,
            numericality: { less_than_or_equal_to: 10000,     greater_than: 0 }

  def self.seven_days_products
    where('created_at > ?', (Time.zone.now.end_of_day - 7.days)).count
  end

  def self.month_products
    where('created_at > ?', (Time.zone.now.end_of_day - 30.days)).count
  end

  def self.total_products
    count
  end

  def self.by_categories(categ_id)
    select("products.id, products.name").
    joins("JOIN categories ON categories.id = products.category_id").
    where(:category_id => categ_id)
  end

  
  # category.products

  def self.times_ordered(prod_id)
    select("*").
    joins("JOIN order_contents ON order_contents.product_id = products.id").
    joins("JOIN orders ON order_contents.order_id = orders.id").
    where.not("orders.checkout_date" => nil).
    where("products.id" => prod_id).count
  end

  def self.times_in_carts(prod_id)
    select("*").
    joins("JOIN order_contents ON order_contents.product_id = products.id").
    joins("JOIN orders ON order_contents.order_id = orders.id").
    where("orders.checkout_date" => nil).
    where("products.id" => prod_id).count
  end

end
