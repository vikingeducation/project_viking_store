class Admin::OrdersController < ApplicationController
  layout 'admin'

  def index
    if User.exists?(params[:user_id])
      @user = User.find(params[:user_id])
      @orders = @user.orders
    else
      @orders = Order.limit(25)
    end
  end

  def show
    return redirect_to admin_orders_path  unless Order.exists?(params[:id])
    @order = Order.find(params[:id])
    @order_contents = @order.order_contents
  end

  def new
    @user = User.find(params[:user_id]) if User.exists?(params[:user_id])
    return redirect_to admin_users_path unless @user
    @order = @user.orders.build
    @cards = credit_card_options || []
  end

  def create
    @user = User.find(params[:user_id])
    @order = @user.orders.build(new_order_params)
    @cards = credit_card_options
    if @user.save
      flash[:warning] = "You may now go on to place your order"
      redirect_to edit_admin_order_path(@order)
    else
      flash[:error] = "Sorry! Your order could not be created"
      render :new
    end
  end

  def edit
    return redirect_to admin_orders_path unless Order.exists?(params[:id])
    @order = Order.find(params[:id])
    @order_contents = @order.order_contents

  end

  def update_contents
    @order = Order.find(params[:id])
    @order_contents = @order.order_contents
    if @updated_order = OrderContent.update(content_params.keys, content_params.values)
      remove_unnecessary_records
      flash[:success] = "Order quantities successfully updated"
      return redirect_to admin_order_path(@order)
    else
      flash[:error] = "Sorry, there's something wrong with the form"
      render :edit
    end
  end

  def add_products
    @order = Order.find(params[:id])
    @order_contents = @order.order_contents
    update_or_build
    # product_params[:order_contents].each do |k, v|
    #   update_
    #   @order.order_contents.build("quantity" => v['quantity'], "product_id" => v[:product_id]) unless v[:quantity].empty? && v[:product_id].empty? || v[:quantity].to_i < 1
    # end
    if @order.save
      flash[:success] = "Success! Products added to cart"
      redirect_to admin_order_path(@order)
    else
      flash[:error] = "Something went wrong. That's all we know"
      render :edit
    end

  end

  def destroy
    @order = Order.find(params[:id])
    if @order.destroy
      flash[:success] = "The order was successfully deleted"
      redirect_to admin_orders_path
    else
      flash[:error] = "The order could not be deleted"
      redirect_to admin_order_path(@order)
    end

  end


  private

  def update_or_build
    product_params[:order_contents].each do |k, v|
      next unless Product.exists?(v[:product_id])
      # if it already exists, store the quantity
      # destroy old object
      if o = @order.order_contents.where('product_id = ?', v[:product_id].to_i).first
        o.update_attribute(:quantity, v[:quantity].to_i + o.quantity)
      else
        unless v[:quantity].empty? && v[:product_id].empty? || v[:quantity].to_i < 1
          quantity ||= v[:quantity]
          product_id ||= v[:product_id]
          @order.order_contents.build("quantity" => quantity, "product_id" => product_id)
        end
      end
    end
  end

  def remove_unnecessary_records
    @updated_order.each do |u|
      u.destroy if u.quantity == 0
    end
  end

  def product_params
    ok = {}
    5.times do |i|
      ok[i.to_s] = [:product_id, :quantity]
    end
    params.require(:order).permit(:order_contents => [:quantity, :product_id])

  end

  def content_params
    ok = {}
    @order_contents.each do |o|
      ok[o.id.to_s] = [:quantity]
    end
    params.require(:order_contents).permit(ok)
  end


  def new_order_params
    params.require(:order).permit(:shipping_id, :billing_id, :credit_card_id)
  end

  def credit_card_options
    @user.credit_cards.map do |cc|
      ["Ending in #{cc.card_number[-4..-1]}", cc.id]
    end
  end



end
