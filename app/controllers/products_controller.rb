class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
    @category = Product.belonged_category(params[:id]).first
    @orders = Product.all_orders(params[:id])
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
    @product = Product.new(while_list_params)
    if @product.save
      flash[:success] = ["#{@product.name} is created."]
      redirect_to products_path
    else
      flash[:danger] = @product.errors.full_messages
      @categories = Category.all
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  private

  def while_list_params
    params.require(:product).permit(:name, :price, :category_id, :sku)
  end
end
