class Product < ActiveRecord::Base

  has_many :purchases
  has_many :orders, through: :purchases

  belongs_to :category

  def self.new_products(last_x_days = nil)
    if last_x_days
      where("created_at > ?", Time.now - last_x_days.days).size
    else
      all.size
    end
  end

end
