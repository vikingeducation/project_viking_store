class Category < ActiveRecord::Base
  has_many :products

  has_many :orders, through: :products, source: :order_contents

  validates :name, presence: true, length: { maximum: 30 }

  def self.get_all_products(cat_id)
    Category.select("p.id AS product_id, p.name AS product_name")
      .joins("AS c JOIN products AS p ON c.id=p.category_id")
      .where("c.id=#{cat_id}")
      .order("p.id")
  end
end
