class Category < ActiveRecord::Base
  has_many :products
  has_many :orders, :through => :products

  validates :name, :presence => true,
                   :length => { :in => 4..16 }



  def self.list_all_categories
    categories = []
    Category.all.each { |cat| categories << cat.name }
    categories
  end

end
