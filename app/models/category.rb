class Category < ApplicationRecord
  has_many :products

  has_many :orders,
           :through => :products

  validates :name, :presence => true,
                   :length => { within: 4..16 }


  def self.all_related_products(id)
    Category.select("products.*").joins("JOIN products ON categories.id = category_id").where("category_id = #{id}")
  end
end
