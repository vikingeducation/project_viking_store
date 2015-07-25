class Product < ActiveRecord::Base

  def self.in_last(days=nil)
    if days.nil?
      self.count
    else
      self.where('created_at > ?', DateTime.now - days).count
    end
  end

  def category
    Category.find_by(id: self.category_id)
  end
end
