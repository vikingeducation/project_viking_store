class Admin::OrderContentsController < ApplicationController

  def index
  end

  def show
  end

  # def new
  #   @order_content = OrderContent.find(params[:order_id])
  # end

  # def create
  #   @order_content = OrderContent.new(whitelisted_order_content_params)
  #   if @order_content.save
  #     flash[:success] = "New Content of the Order has been created"
  #     redirect_to :back
  #   else
  #     flash.now[:danger] = "New Content of the Order WAS NOT saved. Try again."
  #     # render 'new', :locals => {:order => @order}
  #   end
  # end

  def edit
    @order = Order.find(params[:id])
    @order_contents = OrderContent.where(:order_id => @order.id)
  end

  def update
    # @order_contents = OrderContent.where(:order_id => @order.id)
    @order_contents = OrderContent.find(params[:id])
    # @order_contents = OrderContent.where(:order_id => @order.id)
    if @order_contents.update_attributes(whitelisted_order_content_params)
      flash.now[:success] = "New Content of the Order has been updated"
      redirect_to admin_order_path
    else
      flash[:danger] = "New Content of the Order hasn't been saved."
      render 'edit', :locals => {:order_content => @order_content}
    end
  end

  def destroy
    @order_content = OrderContent.find(params[:id])
    if @order_content.destroy
      flash[:success] = "Order Content deleted successfully!"
      redirect_to :back
    else
      flash[:danger] = "Failed to delete the order content"
      redirect_to edit_admin_order_path, :locals => {:order_content => @order_content}
    end
  end

  private
  # def whitelisted_order_content_params
  #   params.require(:order_content).permit(:order_id, :product_id, :quantity)
  # end

  def whitelisted_order_content_params
    params.require(:order_content).permit(:order_id, :product_id, :quantity, :order_contents_id)
  end

end
