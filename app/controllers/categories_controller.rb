class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end
  def show
    @category = Category.find(params[:id])
  end

 def new
   @category = Category.new
 end

 def create
   @category = Category.new(Category_params)
   if @category.save
     flash[:success] = "Category Created!"
     redirect_to @category
   else
     render 'new'
   end
 end

 def edit
   @category = Category.find(params[:id])
 end

 def update
   @category = Category.find(params[:id])
   if @category.update_attributes(Category_params)
     flash[:success] = "Update successful!"
     redirect_to @categories
   else
     flash[:warning] = "Category did not update, please try again."
     render 'edit'
   end
 end

 def destroy
  @category = Category.find(params[:id])
  confirm
  if @category.delete
   flash[:success] = "Category deleted!"
   redirect_to @categories
  else
    flash[:warning] = "Category was not deleted, please try again."
    render 'index'
  end
 end

end
