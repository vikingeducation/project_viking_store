class ProductsController < ApplicationController
  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
    binding.pry
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = 'Success!'
      redirect_to products_path
    else
      flash.now[:warning] = @product.errors.full_messages
      @categories = Category.all
      render :new
    end
  end

  def show
    id = params[:id]
    @product = Product.find(params[:id])
    @category = Product.category(@product.id)
    @times = Product.times_ordered(params[:id])
    @carts = Product.carts_in(params[:id])
  end

  def edit
    @product = Product.find(params[:id])
    @categories = Category.all
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      flash[:success] = 'Success!'
      redirect_to products_path
    else
      flash.now[:warning] = @product.errors.full_messages
      @categories = Category.all
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      flash[:success] = "Success!"
      redirect_to products_path
    else
      flash[:warning] = @category.errors.full_messages
      redirect_to(:back)
    end
  end

  def index
    @products = Product.with_column_names
  end

  private

  def product_params
    params.require(:product).permit(:id, :name, :price, :category_id, :sku)
  end
end
