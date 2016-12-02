class Product < ApplicationRecord
  belongs_to :category

  validates :name, :description, :sku, :category_id, :price, presence: true


  def self.after(time_period, column_name = 'created_at')
  	where("#{column_name} > ?",time_period)
  end
end
