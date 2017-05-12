class Product < ApplicationRecord
  validates :name, :price, :category_id, :presence => true
  validate :price_range
  validate :category_existence
  validate :product_existence, :on => :edit

  # ----------------------------------------------------------------
  # Validation Methods
  # ----------------------------------------------------------------

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

  def product_existence
    unless Product.where(:id => params[:id]).first
      errors.add(:category_id, "The product to be edited must exist already")
    end
  end

  # ----------------------------------------------------------------
  # Queries
  # ----------------------------------------------------------------

  def self.carts_in(id)
    find_by_sql(
    ["SELECT *
      FROM products p
      JOIN order_contents oc ON oc.product_id = p.id
      JOIN orders o ON o.id = oc.order_id
      WHERE p.id = ?
        AND o.checkout_date IS NULL", id]
    ).count
  end

  def self.get_all_with_category
    find_by_sql(
    "SELECT p.*, c.name AS category
       FROM products p
       JOIN categories c ON c.id = p.category_id"
    )
  end

  def self.get_with_category(id)
    find_by_sql(
    ["SELECT p.*, c.name AS category
       FROM products p
       JOIN categories c ON c.id = p.category_id
      WHERE p.id = ?", id]
    ).first
  end

  def self.times_ordered(id)
    find_by_sql(
    ["SELECT *
      FROM products p
      JOIN order_contents oc ON oc.product_id = p.id
      JOIN orders o ON o.id = oc.order_id
      WHERE p.id = ?
        AND o.checkout_date IS NOT NULL", id]
    ).count
  end



end
