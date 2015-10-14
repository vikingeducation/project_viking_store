class Category < ActiveRecord::Base

  validates :name, :presence => true,
                   :length => { :in => 3..15 }

  def self.list_all_categories

    categories = []
    Category.all.each { |cat| categories << "#{cat.id}:  #{cat.name}" }
    categories

  end
                   
end
