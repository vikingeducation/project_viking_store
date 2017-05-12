class Product < ApplicationRecord
  validates :name, :price, :category_id, :presence => true
  validate :price_range
  validate :category_existence

  def price_range
    min, max = 0, 10_000
    if price
      if (price < min) || (price > max)
        errors.add(:price, "Price must be a value between #{min} and #{max}")
      end
    end
  end

  def category_existence
    unless Category.where(:id => category_id).first
      errors.add(:category_id, "The selected category must be a real one")
    end
  end

  def self.get_with_category
    find_by_sql(
    "SELECT p.*, c.name AS category
       FROM products p
       JOIN categories c ON c.id = p.category_id"
    )
  end

end
