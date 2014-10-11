class ProductsController < ApplicationController

  def index
    @products = Product.all
    render :layout => "admin_interface"
  end

  def new
    @product = Product.new
  end

  def create
    params[:product][:price] = strip_currency_symbol((params[:product][:price]).to_s)
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "New Product #{@product.title} created!"
      redirect_to products_path
    else
      flash[:error] = "Whoops!"
      render 'new'
    end
  end

  def edit
  end

  def show
    @product = Product.find(params[:id])

    @times_ordered = @product.times_ordered
    @carts_in = @product.carts_in
  end

  private
  def product_params
    params.require(:product).permit(:title, :price, :sku, :description, :category_id)
  end

  def strip_currency_symbol(price)
      price.gsub(/[^\d*\.\d*]/,"").to_f.round(2)
  end

end
