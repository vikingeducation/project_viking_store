class ProductsController < ApplicationController

def show
	@product = Product.find(params[:id])
end

def self.get_products
  Products.all
end
end
