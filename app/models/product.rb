class Product < ActiveRecord::Base

  def self.total(days=nil)
    if days.nil?
      self.all.count
    else
      self.all.where("created_at > CURRENT_DATE - interval '#{days} day' ").count
    end
  end

end
