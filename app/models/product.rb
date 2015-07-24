class Product < ActiveRecord::Base

  def self.in_last(days = 10000)
    self.where('created_at > ?', DateTime.now - days)
  end

end
