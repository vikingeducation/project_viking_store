class ProductsController < ApplicationController

  layout 'portal'

  def index

    @product = Product.all
    @available_categories = Category.list_all_categories

  end

  def show

    @product = Product.find(params[:id])
    @available_categories = Category.list_all_categories
    @times_ordered = @product.times_ordered
    @prods_in_cart = @product.prods_in_cart

  end

  def new

    @product = Product.new
    @available_categories = Category.all

  end

  def create

    @product = Product.new(product_params)

    @product.price = format_price(params[:product][:price])

    @product.sku = Product.generate_new_sku

    if @product.save
      flash[:success] = "Product created successfully!"
      redirect_to products_path
    else
      flash.now[:danger] = "Product failed to be created - please try again."
      @available_categories = Category.all
      render :new
    end

  end

  def edit

    @product = Product.find(params[:id])
    @available_categories = Category.all

  end

  def update

    @product = Product.find(params[:id])

    if @product.update(product_params)
      flash[:success] = "Product updated successfully!"
      redirect_to products_path
    else
      flash.now[:danger] = "Product failed to update - please try again."
      @available_categories = Category.list_all_categories
      render :edit
    end

  end

  def destroy

    @product = Product.find(params[:id])

    if @product.destroy
      flash[:success] = "Product deleted successfully!"
      redirect_to products_path
    else
      flash[:danger] = "Product failed to be deleted - please try again."
      redirect_to :back
    end

  end

  def product_params

    params.require(:product).permit(:name, :price, :category_id)

  end

  # in case dollar sign is input; method removes the $
  def format_price(price_param)

    if price_param.match(/\$.+/)
      price_param[1..-1].to_f
    else
      price_param.to_f
    end

  end

end
