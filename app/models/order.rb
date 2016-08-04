class Order < ActiveRecord::Base
  def self.get_count(time = nil)
    return self.where("checkout_date IS NOT NULL").count if time.nil?
    days_ago = time.days.ago
    self.where("checkout_date IS NOT NULL AND checkout_date > ?", days_ago).count
  end

  # def self.get_count_by_day(time = 0)

  #   days_ago = time.days.ago
  #   next_day = (time-1).day.ago
  #   self.where("checkout_date BETWEEN ? AND ?" , days_ago, next_day )
  #   raise

  #   #self.where("checkout_date IS NOT NULL AND ? = ?", checkout_date.to_date, time.days.ago.to_date).count
  # end
  


  

end
