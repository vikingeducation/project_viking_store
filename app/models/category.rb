class Category < ActiveRecord::Base
  has_many :products
  has_many :orders, :through => :products

  validates :name, :presence => true,
                   :length => { :in => 4..16 }



  def self.list_all_categories
    Category.all
  end

end
