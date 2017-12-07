class ProductsController < ApplicationController

  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all.order('name')
  end

  def new
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
