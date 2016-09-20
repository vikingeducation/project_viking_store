class Category < ActiveRecord::Base
  validates :name, :presence => true, :length => { :in => 4..16 }

  has_many :products, dependent: :nullify

  has_many :orders, :through => :products

  def self.products(category_id)
    self.select("products.*")
        .join_with_products
        .where("categories.id = #{category_id}")
  end

  def self.join_with_products
    joins("JOIN products ON categories.id = products.category_id")
  end
end
