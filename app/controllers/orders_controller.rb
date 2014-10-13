class OrdersController < ApplicationController

  def index
    @orders = Order.all
    @user = User.find(params[:user_id]) if params[:user_id]
  end

  def show
    @order = Order.find(params[:id])
    @user = @order.user
  end

  def edit
    @order = Order.find(params[:id])
    @user = @order.user
  end

  def new
    @order = Order.new
    @user = User.find(params[:user_id])
  end

  def create
    @order = Order.new(whitelisted_params)
    @order.checked_out = false
    if @order.save
      flash[:success] = "New order saved."
      redirect_to @order
    else
      flash.now[:error] = "Something was invalid."
      render :new
    end
  end

  def update
    @order = Order.find(params[:id])
    @user = User.find(params[:order][:user_id])

    #special hidden params to ID which edit form was used
    update_purchases if params[:order][:update]
    add_contents if params[:order][:add]

    @order.checkout_date = Time.now if new_checkout?(@order)


    if @order.update(whitelisted_params)
      flash[:success] = "Updated!"
      redirect_to @order
    else
      flash.now[:error] = "Something went wrong."
      render :edit
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    if Order.find(params[:id]).destroy
      flash[:success] = "Deleted."
      redirect_to action: :index
    else
      flash[:error] = "Something went wrong in that deletion."
      redirect_to session.delete(:return_to)
    end
  end

  private

  def add_contents
    additions = parsed_additions

    additions.each do |id, quantity|

      next if id == 0 || quantity == 0
      if @order.products.exists?(id)
        purchase = @order.purchases.find_by(:product_id => id)
        purchase.update(:quantity => quantity)
      elsif Product.exists?(id)
        purchase = Purchase.create(:order_id => @order.id,
                                   :product_id => id,
                                   :quantity => quantity)
        purchase.save
      else
        flash[:error] = "Some of these products don't exist!"
      end
    end

  end

  def parsed_additions
    new_items = Hash.new(0)

    1.upto(5) do |index|
      product_id = params[:order][:product_id][index.to_s].to_i
      product_quantity = params[:order][:product_quantity][index.to_s].to_i
      next if product_quantity < 0
      new_items[product_id] += product_quantity
    end
    new_items
  end

  def update_purchases
    @purchases = {}

    params[:order][:quantity].each do |purchase_id, quantity|
      #ignores anything below 0, assuming it was a mistake
      if quantity.to_i > 0
        Purchase.find(purchase_id).update(quantity: quantity)
      elsif quantity.to_i == 0
        Purchase.find(purchase_id).destroy
      end
    end
  end

  def new_checkout?(order)
    params[:order][:checked_out] && !order.checked_out
  end

  def whitelisted_params
    params.require(:order).permit(:checked_out, :user_id,
                               :shipping_id, :billing_id, :checkout_date)
  end

end