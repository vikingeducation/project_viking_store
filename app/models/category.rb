class Category < ActiveRecord::Base

  validates :name, :presence =>true,
                   :length => { :in => 3..15 }
                   
end
