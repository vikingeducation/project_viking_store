class Cart < ActiveRecord::Base
  attr_accessor :product_ids, :order_contents, :id
  def initialize
    super
    @product_ids = []
    @order_contents = []
    @id = 99999
  end

  def update(params)

  end

  def products
    Product.where(:id => @product_ids)
  end

  def order_value(id)
    sum = 0
    products.each{|prod| sum += prod.price}
    sum
  end



end
