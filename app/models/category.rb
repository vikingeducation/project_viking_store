class Category < ActiveRecord::Base

  validates :name, :presence => true,
                   :length => { :in => 3..15 }

  has_many :products, :dependent => :nullify
  has_many :orders, :through => :products

  def self.list_all_categories

    categories = []
    Category.all.each { |cat| categories << "#{cat.id}:  #{cat.name}" }
    categories

  end
                   
end
