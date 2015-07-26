class CategoriesController < ApplicationController
  def index
    @categories = Category.all.order(:id)
  end

  def new
    @category = Category.new
  end

  def show
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(whitelist_category_params)
    if @category.save
      flash[:success] = "Category #{@category.name} successfully created!"
      redirect_to @category
    else
      flash.now[:danger] = 'Oops, there was an error creating your category'
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(whitelist_category_params)
      flash[:success] = "Category #{@category.name} successfully updated!"
      redirect_to @category
    else
      flash.now[:danger] = 'Oops, there was an error updating your category'
      render :edit
    end
  end

  def destroy
    cat_id = params[:id]
    @category = Category.find(cat_id)
    if @category.destroy
      deassociate_products(cat_id)
      flash[:success] = "Category #{@category.name} successfully deleted!"
      redirect_to categories_path
    else
      flash.now[:danger] = 'Oops, there was an error deleting your category'
      render @category
    end
  end

  private
    def whitelist_category_params
      params.require(:category).permit(:name, :description)
    end

    def deassociate_products(id)
      Product.where(category_id: id).update_all(category_id: nil)
    end
end
