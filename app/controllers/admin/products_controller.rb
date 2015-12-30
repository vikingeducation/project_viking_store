class Admin::ProductsController < ApplicationController
  layout 'admin'
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show
    @category = Category.find(@product.category_id)
  end

  def edit
  end

  def new
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
