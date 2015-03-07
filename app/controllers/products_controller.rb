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

  private

  def list_of_category_names
    Category.all.each_with_object([]) do |cat, list|
      list << cat.name
    end
  end
end
