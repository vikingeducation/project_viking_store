class Order < ActiveRecord::Base

  def self.total(days=nil)
    if days.nil?
      self.all.count
    else
      self.all.where("checkout_date > CURRENT_DATE - interval '#{days} day' ").count
    end
  end
  
end
