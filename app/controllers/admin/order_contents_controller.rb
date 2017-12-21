class Admin::OrderContentsController < ApplicationController


  def new
  end


  def create_multiple
    @order = Order.find(params[:order_id])
    @order_contents = @order.order_contents
    @errors = []
    params[:order_contents].each do |x, hash|
      if !@order_contents.where(product_id: hash["product_id"]).first.nil?
        @order_contents.where(product_id: hash["product_id"]).update_all(quantity: @order_contents.where(product_id: hash["product_id"]).first.quantity += hash["quantity"].to_i)
      else
        order_content = @order_contents.build(product_id: hash["product_id"], quantity: hash["quantity"] )
        unless order_content.product_id.nil? && order_content.quantity.nil?
          if !order_content.save
            @errors << order_content.errors
          end
        end
      end
    end
    if @errors.empty?
      flash[:success] = "Successfully Added Products to Order ##{@order.id}!"
      redirect_to admin_order_path(@order)
    else
      flash[:danger] = "Products NOT Added to Order ##{@order.id} - #{@errors.first.full_messages.join(', ')}"
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
    params[:order_contents].each do |id, quantity|
      if quantity == "0"
        OrderContent.find(id).destroy
        flash[:danger] = "Removed Product(s) From Order"
      else
        OrderContent.find(id).update_attribute(:quantity, quantity)
        flash[:success] = "Order Contents Successfully Updated!"
      end
    end
    redirect_to admin_order_path(@order)
  end


end
