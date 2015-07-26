class CategoriesController < ApplicationController

def index
  @category=Category.all
  @table_data=@category
  #@prices=Categories.get_prices
  @headers=["ID","name","Description","SHOW","EDIT","DELETE"]
end

def new
  @category=Category.new
end

def create
  @category=Category.new(whitelist_category_input)

  if @category.save
    flash.notice = "Category created"
    redirect_to categories_path
  else
    flash.now.notice = "Failed"
    render :new
  end
end

def show
	@category = Category.find(params[:id])
  @products=Product.all
end

def edit
  @category= Category.find(params[:id])
end

def update
  @category= Category.find(params[:id])
  if @category.update(whitelist_category_input)
    flash.notice = "Category updated"
    redirect_to category_path(@category.id)
  else
    render :edit
  end
end

def destroy
  @category= Category.find(params[:id])
  if @category.destroy
    flash.notice = "Category deleted"
    redirect_to categories_path
  else
    flash.now.notice = "Category is not deleted"
    render :edit
  end

end

def whitelist_category_input
  params.require(:category).permit(:name, :description)
end

end
