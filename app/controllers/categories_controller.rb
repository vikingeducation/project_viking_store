class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(whitelisted_params)

    if @category.save
      flash[:success] = "New category saved."
      redirect_to action: :index
    else
      flash.now[:error] = "Something was invalid."
      render :new
    end
  end

  def show
    @category = Category.find(params[:id])
  end

  def edit
    @category = Category.find(params[:id])

  end

  def update
    @category = Category.find(params[:id])

    if @category.update(whitelisted_params)
      flash[:success] = "Updated!"
      redirect_to action: :index
    else
      flash.now[:error] = "Something went wrong."
      render :edit
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    if Category.find(params[:id]).destroy
      flash[:success] = "Deleted."
      redirect_to action: :index
    else
      flash[:error] = "Something went wrong in that deletion."
      redirect_to session.delete[:return_to]
    end
  end

private

  def whitelisted_params
    params.require(:category).permit(:name)
  end

end
