class Order < ActiveRecord::Base
  def self.get_count(time = nil)
    self.where("checkout_date IS NOT NULL").count if time.nil?
  end
  

end
