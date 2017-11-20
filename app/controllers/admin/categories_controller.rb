module Admin
  class CategoriesController < ApplicationController
    layout "admin"
    before_action :set_category, only: [:edit, :update, :destroy, :show]

    def index
      @categories = Category.all
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)

      if @category.save
        flash[:success] = "Category #{@category.name} Created!!!"
        redirect_to admin_categories_path
      else
        render :new
      end
    end

    def update
      if @category.update(category_params)
        flash[:success] = "Category #{@category.name} Has Been Updated!!!"
        redirect_to admin_categories_path
      else
        flash.now[:error] = "Something Went Wrong!"
        render :edit
      end
    end

    def destroy
      if @category.destroy
        flash[:success] = "Category #{@category.name} Has Been Deleted!!!"
      else
        flash.now[:error] = "Something Went Wrong!"
      end

      redirect_to admin_categories_path
    end

    private

    def category_params
      params.require(:category).permit(:name)
    end

    def set_category
      @category = Category.find(params[:id])
    end
  end
end
