class Admin::CategoriesController < ApplicationController
  layout 'admin'
  def show
    @category = Category.find(params[:id])
    @products = Product.products_in_category(params[:id])
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(whitelisted_categories)
      flash[:success] = "Success! Your category has been updated"
      redirect_to admin_category_path(@category)
    else
      flash[:error] = "We couldn't update the category. Please check the form for errors!"
      render :edit
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(whitelisted_categories)
    if @category.save
      flash[:success] = 'Your category was created'
      redirect_to admin_categories_path
    else
      flash.now[:error] = "Your category was not created"
      render :new
    end

  end

  def index
    @categories = Category.all.order('id')
    render  locals: { rows: @categories, headings: ['id', 'name']}
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.delete
      flash[:success] = 'Your category was deleted'
    else
      flash[:error] = "Sorry, that category can't be deleted"
    end
    redirect_to admin_categories_path
  end

  private

  def whitelisted_categories
    if params[:category]
      params.require(:category).permit(:name, :description)
    else
      params.permit(:name, :description)
    end
  end


end
