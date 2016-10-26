class User < ApplicationRecord
  has_many :addresses
  has_many :orders
  
  def self.after(time_period, column_name = 'created_at')
  	where("#{column_name} > ?",time_period)
  end
end
