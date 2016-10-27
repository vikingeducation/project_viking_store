class User < ApplicationRecord
  has_many :addresses
  has_many :orders
  has_many :credit_cards

  def self.after(time_period, column_name = 'created_at')
  	where("#{column_name} > ?",time_period)
  end
end
