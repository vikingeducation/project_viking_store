class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def edit
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def show
    @category = Category.find(params[:id])
  end

  def destroy
    Category.find(params[:id]).destroy
    flash[:success] = "Category #{params[:id]} deleted."
    redirect_to categories_path
  end

  def create
  @category = Category.new(cat_params)
    if @category.save
      flash[:success] = "Category #{params[:id]} created!"
      redirect_to categories_path
    else
      flash[:error] = "Whoops!"
      render 'new'
    end
  end

  def update
    @category = Category.find(params[:id])
    old_name = @category.name
    if confirm_category( @category.id ) # TODO - put this in the model as callback (maybe)
      if @category.update(cat_params)
        flash[:success] = "Category #{old_name} edited to #{@category.name}"
        redirect_to @category
      else
        flash[:error] = "Whoops!"
        render 'edit'
      end
    else
      render 'edit'
    end
  end

  private
  def cat_params
    params.require(:category).permit(:name, :description)
  end

  def confirm_category(cat_num)
    params[:id] == cat_num.to_s
  end

end
