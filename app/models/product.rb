class Product < ActiveRecord::Base
  def self.total
    count
  end
end
