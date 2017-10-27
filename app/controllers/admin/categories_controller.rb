class Admin::CategoriesController < ApplicationController

  layout 'admin_portal_layout'

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end


  def create
    @category = Category.new(whitelisted_params)
    if @category.save
      redirect_to admin_category_path(@category)
    else
      render :new
    end
  end


  def edit
    set_category
  end


  def show
    set_category
  end


  def update
    set_category
    if @category.update(whitelisted_params)
      redirect_to admin_category_path(@category)
    else
      render :edit
    end
  end


  def destroy
    set_category
    @category.destroy
    redirect_to admin_categories_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def whitelisted_params
    params.require(:category).permit(:name)
  end


end
