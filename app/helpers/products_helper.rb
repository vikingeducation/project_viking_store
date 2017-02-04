module ProductsHelper
	def products_params
    	params.require(:product).permit(:name, :description, :price, :category_id)
  	end
end
