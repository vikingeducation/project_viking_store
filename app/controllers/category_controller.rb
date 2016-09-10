class CategoryController < ApplicationController
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    new_category = Category.new(whitelist_params)
    if new_category.save
      flash[:success] = "yeah, new category created!"
      redirect_to category_index_path
    else
      @category = new_category
      show_errors(@category.errors.messages)
      render :new
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(whitelist_params)
      flash[:success] = "yeah, category updated!"
      redirect_to category_index_path
    else
      show_errors(@category.errors.messages)
      render :edit
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def show
    @category = Category.find(params[:id])
    @products = Category.products(params[:id])
  end

  def destroy
    category = Category.find(params[:id])
    if category
      category.destroy
      flash[:success] = "category #{category.name} deleted!"
      redirect_to category_index_path
    else
      render :index
    end
  end

  private
    def whitelist_params
      params.require(:category).permit(:name, :description, :due_date)
    end

    def show_errors(messages)
      flash.now[:danger] = []
      messages.each do |type, errors|
        errors.each do |err|
          flash.now[:danger] << type.to_s.titleize + " " + err
        end
      end
    end
end
