class Product < ActiveRecord::Base
  belongs_to :category

  # Returns all the products
  # with a created_at date after the given date
  def self.count_since(date)
    Product.where('created_at > ?', date).count
  end
end
