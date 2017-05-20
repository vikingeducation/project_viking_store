class Admin::OrdersController < ApplicationController
  layout "admin"
  include AdminHelper

  def index
    @orders = get_orders
    @orders = @orders.where(:checkout_date => nil) if filter_by_unplaced?
    @orders = @orders.limit(100)
  end

  def show
    @order = Order.value_per_order.find(params[:id])
    @order_contents = @order.order_contents.includes(:product)
  end

  def new
    @user = User.find(params[:user_id])
    @order = @user.orders.build
    @address_options = @user.addresses.map{ |a| [full_address(a), a.id] }
    @credit_card_options = credit_card_options(@user.credit_cards)
  end

  def create
    @user = User.find(order_params[:user_id])
    @order = @user.orders.build(order_params)
    # Will not accept order without those addresses specified and
    # valid (belong to that user)
    if @user.address_ids.include?(order_params[:shipping_id].to_i) &&
       @user.address_ids.include?(order_params[:billing_id].to_i)
      if @order.save
        flash[:success] = "Order created successfully"
        redirect_to edit_admin_order_path(@order.id)
      else
        @address_options = @user.addresses.map{ |a| [full_address(a), a.id] }
        @credit_card_options = credit_card_options(@user.credit_cards)
        flash[:danger] = "Failed to create order"
        render :new
      end
    else
      # set remaining vars for `new` view
      @address_options = @user.addresses.map{ |a| [full_address(a), a.id] }
      @credit_card_options = credit_card_options(@user.credit_cards)
      flash.now[:danger] = "The specified addresses must belong to you"
      render :new
    end
  end

  def edit
    set_edit_variables
  end

  def update_order_contents
    # loop through order contents to update them
    params[:order_content].each do |oc_id, quantity|
      order_content = OrderContent.find(oc_id)
      if quantity.to_i == 0
        order_content.destroy
      else
        order_content.update(:quantity=>quantity)
      end
    end
    flash[:success] = "Order Contents updated successfully"
    redirect_to admin_order_path(params[:id])
  end

  def create_order_contents
    # loop  through product_id and quantity
    @order = Order.find(params[:id])
    sanitized_params = params[:order_content].map do |i, keyvals|
      keyvals
    end.select do |keyvals|
      !keyvals[:product_id].blank? || !keyvals[:quantity].blank?
    end
    # if there's an invalid product id, cancel, show error msg
    product_ids = sanitized_params.map{|kv| kv[:product_id]}
    invalid_product_ids = product_ids.select{ |id| Product.find_by(:id=>id).nil? }
    if !invalid_product_ids.empty?
      flash[:warning] = "Invalid Product ID: #{invalid_product_ids}"
      set_edit_variables
      render :edit
    else
      # create an order content
      OrderContent.transaction do
        sanitized_params.each do |kv|
          # if there's an order_content for that product id, update that
          # TODO: check quantity is a positive integer; handle when it's not
          order_content = @order.order_contents.find_by(:product_id => kv[:product_id])
          if order_content
            new_quantity = order_content.quantity + kv[:quantity].to_i
            order_content.update(:quantity => new_quantity)
          else
            params_ = {:product_id => kv[:product_id], :quantity => kv[:quantity]}
            @order.order_contents.build(params_)
            @order.save!
          end
        end
        flash[:success] = "Product added with success"
        redirect_to admin_order_path(@order.id)
      end
    end
  end


  # ------------------------------------------------------------------------
  # Helpers
  # ------------------------------------------------------------------------

  def get_orders
    # Filter addresses by user, if provided
    if params[:user_id]
      if User.exists?(params[:user_id])
        # The view is cutomized based on the presence of the `@user` var
        @user = User.find(params[:user_id])
        Order.value_per_order.where(:user_id => @user.id)
      else
        flash[:warning] = "The user_id #{params[:user_id]} does not exist"
        false
      end
    else
      Order.value_per_order
    end
  end

  def filter_by_unplaced?
    if params[:status]
      params[:status].to_sym == :unplaced
    end
  end

  def order_params
    params.require(:order).permit(
    :user_id, :shipping_id, :billing_id, :credit_card_id)
  end

  def set_edit_variables
    @order = Order.find(params[:id]) unless @order
    @user = @order.user unless @user
    @order_contents = @order.order_contents
    @address_options = @user.addresses.map{ |a| [full_address(a), a.id] } unless @address_options
    @credit_card_options = credit_card_options(@user.credit_cards) unless @credit_card_options
  end

end
