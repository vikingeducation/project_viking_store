class Product < ActiveRecord::Base

  belongs_to :category,
              inverse_of: :products    

  has_many :order_contents,
            inverse_of: :products

  has_many :orders,
            through: :order_contents,
            inverse_of: :products


  def self.total_products_in_last_n_days( n )
    Product.where("created_at > ( CURRENT_DATE - #{n} )").count
  end
end
