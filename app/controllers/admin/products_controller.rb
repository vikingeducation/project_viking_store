class Admin::ProductsController < ApplicationController
  layout "admin"

  def index
    @products = Product.get_all_with_category
  end

  def new
    @product = Product.new
    @category_options = Category.all.map{ |c| [c.name, c.id] }
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "Product created successfully"
      redirect_to root_path
    else
      flash[:danger] = "Failed to create product"
      @category_options = Category.all.map{ |c| [c.name, c.id] }
      render :new
    end
  end

  def show
    @product = Product.get_with_category(params[:id])
    @times_ordered = Product.times_ordered(params[:id])
    @carts_in = Product.carts_in(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :category_id)
  end

end
