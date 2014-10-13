class OrdersController < ApplicationController

  def show
    @order = Order.find(params[:id])
  end

  def destroy

  end

  def edit
    @order = Order.find(params[:id])
  end

  def update

  end

# ---- utility methods ----

  private

  def order_params
#    params.require(:product).permit(:title, :price, :sku, :description, :category_id)
  end

end # class
