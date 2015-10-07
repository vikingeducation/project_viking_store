class OrdersController < ApplicationController
  def index
      @orders = Order.all.order("user_id asc")
  end

  def show
    @order = Order.find(params[:id])
    @user = @order.user
    @credit = @order.credit_card
    @quantity = order_numbers(@order)
    @value = order_value(@order)
    @definition = placed_or_not(@order)
    @contents = @order.order_contents
  end


  def destroy
    @order = Order.find(params[:id])
    puts "find"
    @order.destroy
    redirect_to orders_path
  end



private
  def order_numbers(order)
    count = 0
    order.order_contents.each do |oo|
      count += oo.quantity
    end
    return count
  end

  def order_value(order)
    value = 0
    order.order_contents.each do |oo|
      value += oo.product.price * oo.quantity
    end
    return value
  end

  def placed_or_not(order)
    if order.checkout_date != nil
          return ["Order","Placed"]
        else
          return ["Shopping Cart","UnPlaced"]
        end
  end


end
