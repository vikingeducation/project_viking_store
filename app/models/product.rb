class Product < ApplicationRecord
  belongs_to :category


  def self.after(time_period, column_name = 'created_at')
  	where("#{column_name} > ?",time_period)
  end
end
