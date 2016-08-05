class ProductsController < ApplicationController

  def index
    @products = Product.all
    render :index, layout: "admin_layout"
  end

  def new
    @product = Product.new
    @categories = Category.all
    render :new, layout: "admin_layout"
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = "You're product has been saved"
      redirect_to products_path
    else
      flash.now[:alert] = @product.errors.full_messages
      render :new, layout: "admin_layout"
    end
  end

  def edit
    @product = Product.find(params[:id])
    render :edit, layout: "admin_layout"
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      flash[:notice] = "You're product has been updated"
      redirect_to products_path
    else
      flash.now[:alert] = @product.errors.full_messages
      render :edit, layout: "admin_layout"
    end
  end

  def show
    @product = Product.find(params[:id])
    @times_ordered = @product.times_ordered
    @category = @product.product_category
    @num_in_carts = @product.num_in_carts
  end

  def destroy
    session[:return_to] = request.referer
    @product = Product.find(params[:id])
    if @product.destroy
      flash[:notice] = "#{@product.name} has been deleted"
      redirect_to products_path
    else
      flash.now[:alert] = "Failed to delete"
      redirect_to session.delete(:return_to)
    end
  end

  private
    def category_params
      params.require(:category).permit(:name, :description)
    end

end
