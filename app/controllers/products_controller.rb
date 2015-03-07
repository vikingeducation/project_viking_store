class ProductsController < ApplicationController
  def index
    @products = Product.all
    render layout: "admin"
  end

  def show
    @product = Product.find(params[:id])
    render layout: "admin"
  end

  def edit
    @product = Product.find(params[:id])
    @categories = Category.all
    @list_of_category_names = list_of_category_names
    render layout: "admin"
  end

  def destroy
    @product = Product.find(params[:id])
    session[:return_to] ||= request.referer
    if @product.destroy!
      flash[:success] = "That product was deleted."
      redirect_to products_path
    else
      flash[:error] = "It didn't work."
      redirect_to session.delete(:return_to)
    end
  end

  def update
    @product = Product.find params[:id]
    if @product.update whitelisted_product_params
      flash[:success] = "You successfully updated the product."
      redirect_to products_path
    else
      flash[:error] = "There's an error."
      render :edit
    end
  end

  def new
    @product = Product.new
    @list_of_category_names = list_of_category_names
    render layout: "admin"
  end

  def create
    @product = Product.new whitelisted_product_params
    @product.sku = rand(10000000000123012301204102401204)
    if @product.save
      flash[:success] = "You created a new product."
      redirect_to products_path
    else
      asdfaweg.asdfasdf
      flash[:error] = "There was an error."
      render :new
    end
  end

  private

  def list_of_category_names
    Category.all.each_with_object([]) do |cat, list|
      list << cat.name
    end
  end

  def whitelisted_product_params
    clean_up_money
    params.require(:product).permit(:name, :price, :category_id)
  end

  def clean_up_money
    params[:product][:price] = params[:product][:price][1..-1] if params[:product][:price][0] == "$"
  end
end
