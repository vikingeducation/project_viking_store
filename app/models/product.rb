class Product < ApplicationRecord

  def self.get_with_category
    find_by_sql(
    "SELECT p.*, c.name AS category
       FROM products p
       JOIN categories c ON c.id = p.category_id"
    )
  end

end
