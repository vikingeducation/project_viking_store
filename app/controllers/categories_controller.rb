class CategoriesController < ApplicationController

  before_action :set_category, only: [:edit, :show, :update, :destroy]

  def index
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_category
    @category = Category.find_by(id: params[:id])
  end

  def category_params
  end

end
