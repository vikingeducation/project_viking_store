class StoreController < ApplicationController

  def home
    @categories = Category.all  
    
    if params[:cat_id]
      @products = Category.find(params[:cat_id]).products
    else
      @products = Product.all
    end
    
  end
end
