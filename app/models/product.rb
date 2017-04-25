class Product < ApplicationRecord

  belongs_to :category

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
    Product.select("products.id, products.name").
    joins("JOIN categories ON categories.id = products.category_id").
    where(:category_id => categ_id)
  end


end
