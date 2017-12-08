class ProductsController < ApplicationController

  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all.order('name')
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = "Product #{@product.name} has been created. Beeeewm."
      redirect_to products_path
    else
      flash.now[:alert] = "Ah crap. Something went wrong."
      render :new
    end
  end

  def edit
  end

  def _form
  end

  def show
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id])
  end


end
