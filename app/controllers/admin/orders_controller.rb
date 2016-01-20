class Admin::OrdersController < ApplicationController

  layout 'portal'

  def index

    @orders = Order.get_index_data(params[:user_id])

    # keeps track of user if necessary
    begin
      @filtered_user = User.find(params[:user_id]) if params[:user_id]
    rescue
      flash[:danger] = "User not found.  Redirecting to Orders Index."
      redirect_to admin_orders_path
    end

  end

  def show

    @order = Order.find(params[:id])
    @user = @order.user
    @order_status = @order.order_status
    @shipping_address = @order.shipping_address.address_hash
    @billing_address = @order.billing_address.address_hash
    @card = @order.get_card_info
    @order_contents = @order.build_contents

  end

  def new

    @order = Order.new
    @user = User.find(params[:user_id])
    @available_addresses = @user.created_addresses
    @available_cards = @user.credit_cards.all

  end

  def create

    @order = Order.new(order_params)

    if @order.save
      flash[:success] = "Order created successfully!"
      redirect_to edit_admin_order_path(@order.id)
    else
      flash.now[:danger] = "Order failed to be created - please try again."
      @user = User.find(params[:user_id])
      @available_addresses = @user.created_addresses
      @available_cards = @user.credit_cards.all
      render :new
    end

  end

  def edit

    @order = Order.find(params[:id])
    @status = @order.order_status
    @user = User.find(@order.user_id)
    @available_addresses = @user.created_addresses
    @avilable_cards = @user.credit_cards.all
    @order_contents = @order.build_contents

  end

  def update

    @order = Order.find(params[:id])

    # use commit param to control what information is updated

    # update info
    if params[:commit] == 'Update Order Information'
      params[:order][:checkout_date] = @order.update_checkout_date(params[:status])

      if @order.update(order_params)
        flash[:success] = "Order successfully updated!"
        redirect_to [:admin, @order]
      else
        flash.now[:danger] = "Order not saved - please try again."
        @status = @order.order_status
        @user = User.find(@order.user_id)
        @available_addresses = @user.created_addresses
        @available_cards = @user.credit_cards.all
        render :edit
      end
    end


    # update contents
    if params[:commit] == 'Update Order Contents'
      #update quantity for order/product id combo
      @order_contents = @order.order_contents

      @order_contents.each do |row|
        new_quantity = params[row.id.to_s].to_i
        # delete if zero
        row.update(:quantity => new_quantity)
      end

      redirect_to [:admin, @order]
    end


    # add products
    if params[:commit] == 'Add Products'
      # e.g. "new_products"=>{"0"=>{"id"=>"162", "quantity"=>"4"}
      params[:new_products].each do |new_product|

        submitted_product_id = new_product[1][:id].to_i
        # if product_id is valid
        if Product.ids.include?(submitted_product_id)

          # if product is already in Order
          unless @order.product_ids.include?(submitted_product_id)
            # add OrderContent row for it with quantity
            o = OrderContent.new
            o.order_id = @order.id
            o.product_id = submitted_product_id
            o.quantity = new_product[1][:quantity].to_i
            o.save!
          end

        end

      end

      redirect_to [:admin, @order]

    end

  end

  def destroy

    @order = Order.find(params[:id])

    if @order.destroy
      flash[:success] = "Order deleted successfully!"
      redirect_to user_path(@order.user_id)
    else
      flash[:danger] = "Order failed to be deleted - please try again."
      redirect_to :back
    end

  end

  def order_params

    params.require(:order).permit(:checkout_date, :shipping_id, :billing_id, :billing_card_id, :user_id)

  end

  def content_params

    params.require(:order_content).permit(:quantity)

  end

end
