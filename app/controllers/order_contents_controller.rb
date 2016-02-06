class OrderContentsController < ApplicationController
  def edit
    @ordercontent = OrderContent.new
  end

  def update
    @ordercontent = OrderContent.new(order_content_params)
    if @ordercontent.save
      flash[:success] = "Order quantity updated"
    end
    redirect_to edit_order_path(@ordercontent.order.id)
  end

  def destroy
    @ordercontent = OrderContent.find(params[:id])
    if @ordercontent.destroy
      flash[:success] = "Item Removed"
    end
      redirect_toedit_order_path(@ordercontent.order.id)
  end

  private

  def order_content_params
    params.require(:order_content).permit(:quantity)
  end
end
