class Order < ActiveRecord::Base
  def self.get_count(time = nil)
    return self.where("checkout_date IS NOT NULL").count if time.nil?
    days_ago = time.days.ago
    self.where("checkout_date IS NOT NULL AND checkout_date > ?", days_ago).count
  end

  
  

end
