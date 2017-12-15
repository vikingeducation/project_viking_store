class Admin::OrderContentsController < AdminController

  def create
  end

  def edit
  end

  def update
    if OrderContent.update(update_order_contents_params.keys, update_order_contents_params.values)
      flash[:notice] = "Order contents updated!"
      redirect_to :back
    else
      flash.now[:failure] = "Something went wrong..."
      render :index
    end
  end

  private

  def update_order_contents_params
    params.require(:order_content)
  end
end
