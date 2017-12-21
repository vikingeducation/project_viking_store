class Admin::CategoriesController < ApplicationController

  layout 'admin_portal_layout'

  def index
    @categories = Category.all.order(:id)
  end

  def new
    @category = Category.new
  end


  def create
    @category = Category.new(whitelisted_params)
    if @category.save
      flash[:success] = "Category ##{@category.id} Successfully Saved!"
      redirect_to admin_categories_path
    else
      flash[:danger] = "Category Could Not Be Created See Errors On Form"
      render :new
    end
  end


  def edit
    set_category
  end


  def show
    set_category
    @products = Product.all
  end


  def update
    set_category
    if @category.update(whitelisted_params)
      flash[:success] = "Category ##{@category.id} Successfully Updated"
      redirect_to admin_categories_path
    else
      flash[:danger] = "Category ##{@category.id} Could Not Be Updated - See Errors On Form"
      render :edit
    end
  end


  def destroy
    set_category
    if @category.destroy
      flash[:success] = "Category ##{@category.id} Successfully Deleted"
      redirect_to admin_categories_path
    else
      flash[:danger] = "Category ##{@category.id} Could Not Be Destroyed"
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def whitelisted_params
    params.require(:category).permit(:name)
  end


end
