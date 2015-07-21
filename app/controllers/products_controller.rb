class ProductsController < ApplicationController

  layout 'portal'


  def index
    @products = Product.all.order(:id)
  end


  def show
    @product = Product.find(params[:id])
    #@products = @product.products
  end


  def new
    @product = Product.new
    @available_categories = Category.list_all_categories
  end


  def create
    @product = Product.new(product_params)

    @product.price = format_price(params[:product][:price])

    @product.sku = Product.generate_new_sku


    if @product.save
      flash[:success] = "Product successfully created!"
      redirect_to products_path
    else
      flash.now[:danger] = "Product not saved - please try again."
      @available_categories = Category.list_all_categories
      render :new
    end

  end


  def edit
    @product = Product.find(params[:id])
    @available_categories = Category.list_all_categories
  end


  def update
    @product = Product.find(params[:id])

    # check if ID is valid to be edited???

    if @product.update(product_params)
      flash[:success] = "Product successfully updated!"
      redirect_to products_path
    else
      flash.now[:danger] = "Product not saved - please try again."
      @available_categories = Category.list_all_categories
      render :edit
    end
  end


  def destroy
    @product = Product.find(params[:id])

    if @product.destroy
      flash[:success] = "Product deleted!"
      redirect_to products_path
    else
      flash.now[:danger] = "Delete failed - please try again."
      redirect_to :back
    end

  end


  private


  # Silently disallows changes to Product ID, but is there a way (above) to throw an error?
  def product_params
    params.require(:product).permit(:name, :price, :category_id)
  end


  def format_price(price_param)
    if price_param.match(/\$.+/)
      price_param[1..-1].to_f
    else
      price_param.to_f
    end
  end

end