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
  @category=Category.new(whitelist_new_user_input)

  if @category.save
    redirect_to user_path(@category)
  else
    render :new
  end
end

def show
	@category = Category.find(params[:id])
end

def edit
end

def destroy
end

def whitelist_new_user_input
  params.require(:category).permit(:name, :description)
end

end
