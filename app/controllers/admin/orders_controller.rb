class Admin::OrdersController < AdminController
  def index
    @orders = Order.all.order("orders.id")
    @user = params[:user_id].to_i
    if @user != 0
      @user = User.find(@user)
      @orders = @user.orders.order("id")
    end
  end

  def show
    @order = Order.find(params[:id])
    @user = @order.user
    @order_contents = @order.order_contents
  end

  def new
    @order = Order.new
    @user = User.find(params[:user_id])
    @credit_cards = @user.credit_cards
    @card = CreditCard.new
  end

  def create
    @user = User.find(params[:user_id])
    @card = nil
    if params[:credit_card_number]
      @card = CreditCard.create(
        card_number: params[:credit_card_number],
        user_id: params[:user_id],
        exp_month: params[:cc_exp_month],
        exp_year: params[:cc_exp_year])
    elsif params[:order][:credit_card_id]
      @card = CreditCard.find(params[:order][:credit_card_id])
    end

    @order = Order.new(
      billing_id: params[:order][:billing_id],
      shipping_id: params[:order][:shipping_id],
      credit_card_id: @card.id,
      user_id: params[:user_id]
    )

    if @order.save
      flash[:success] = "You've Sucessfully Created an Order!"
      redirect_to edit_admin_order_path(@order)
    else
      flash.now[:error] = "Error! Order wasn't created!"
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
    @user = @order.user
    @credit_cards = @user.credit_cards
    @card = CreditCard.new
    @order_contents = @order.order_contents
  end

  def update
    @order = Order.find(params[:id])
    @user = @order.user
    @credit_cards = @user.credit_cards
    @card = @order.credit_card
    @order_contents = @order.order_contents

    if @order.update(order_params)
      flash[:success] = "You've Sucessfully Updated the Order!"
      redirect_to admin_order_path(@order)
    else
      flash.now[:error] = "Error! Order wasn't created!"
      @order.order_contents = @order.order_contents.reject { |oc| oc.quantity.nil? || oc.id.nil? }
      render :edit
    end
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.destroy
      flash[:success] = "You've Sucessfully an Order!"
      redirect_to admin_orders_path(user_id: @order.user_id)
    else
      flash.now[:error] = "Error! Order wasn't deleted!"
      render :show
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :billing_id,
      :shipping_id,
      :credit_card_id,
      :user_id,
      {
        order_contents_attributes: [:product_id, :quantity, :id]
      }
    )
  end
end
