class Admin::ProductsController < AdminController

  def index
    @products = Product.with_category_names
  end


  def show
    @product = Product.with_category_names.find(params[:id])
    @stats = @product.order_stats
  end


end
