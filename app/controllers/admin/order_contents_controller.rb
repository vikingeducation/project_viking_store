class Admin::OrderContentsController < ApplicationController


  def new
  end


  def create_multiple
    @order = Order.find(params[:order_id])
    @order_contents = @order.order_contents
    @errors = []
    params[:order_contents].each do |x, hash|
      order_content = @order_contents.build(product_id: hash["product_id"], quantity: hash["quantity"] )
      unless order_content.product_id.nil? && order_content.quantity.nil?
        if !order_content.save
          @errors << order_content.errors
        end
      end
    end
    if @errors.empty?
      flash[:success] = "Successfully added products to order!"
      redirect_to admin_order_path(@order)
    else
      flash[:danger] = "Products NOT added to order - #{@errors.first.full_messages.join(", ")}"
      redirect_to edit_admin_order_path(@order)
    end
  end


  def edit
    @order = Order.find(params[:order_id])
    @order_contents = @order.order_contents
  end


  def update_multiple
    @order = Order.find(params[:order_id])
    @order_contents = @order.order_contents
    @errors = []
    params[:order_contents].each do |id, quantity|
      if !OrderContent.find(id).update_attribute(:quantity, quantity)
        @errors << "Failed to update order contents: #{id} "
      end
    end
    if @errors.empty?
      flash[:success] = "Order Contents Successfully Updated!"
      redirect_to admin_order_path(@order)
    else
      flash[:danger] = "Order Contents Not Updated - #{@errors.first.full_messages.join(", ")}"
      redirect_to edit_admin_order_path(@order)
    end
  end


end
