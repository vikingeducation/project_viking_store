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

  private

  def list_of_category_names
    Category.all.each_with_object([]) do |cat, list|
      list << cat.name
    end
  end
end
