class CategoriesController < ApplicationController

def show
	@category = Category.find(params[:id])
end

def edit
end

def destroy
end

end
