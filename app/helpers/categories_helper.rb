module CategoriesHelper
	def categories_params
    	params.require(:category).permit(:name, :description)
  	end
end
