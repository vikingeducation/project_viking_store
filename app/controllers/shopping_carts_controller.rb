class ShoppingCartsController < ApplicationController
  layout 'front_facing'

  # All cart contents are displayed along with unit prices, item prices, and the total cart value
  def edit
    if cart_is_empty?
      redirect_to root_path
      flash[:notice] = "You ain't got no items in your blimey cart."
    else
      @order_contents = order_contents
    end
  end

  def update
    # Getting the order contents before deleting the session shopping cart items.
    order_contents_before_update = order_contents
    session[:shopping_cart_items] = []
    order_contents_before_update.each_with_index do |order_content,index|
      order_content.quantity = params["order_content_#{index}"]["quantity"]
      store_or_destroy_product(order_content, index)
    end
    if cart_is_empty?
      redirect_to shoppingcart_path
      flash[:notice] = "You ain't got no items in your blimey cart."
    else
      @order_contents = order_contents
      flash.now[:alert] = "Cart updated."
      render :edit
    end
  end

  private

  def cart_is_empty?
    if signed_in_user?
      current_user.orders.where(:checkout_date => nil).first.products.empty?
    else
      session[:shopping_cart_items] == nil || session[:shopping_cart_items].size < 1
    end
  end

  # So first off I need to distinguish between whether this cart is pre or post sign_in...
  # If there is a current_user then we can just get that user's order where the checkout_date == nil .first .order_contents and send them in...
  # If there isn't we'll get the order contents from the sessions.
  def order_contents
    if signed_in_user?
      current_user.orders.where(:checkout_date => nil).first.order_contents
    else
      session_cart_as_an_array_of_objects
    end
  end

  # The order contents in the session was coming out as a hash so I am changing them to objects before I send them in so that the view can just deal with the objects.
  # Sometimes sessions seems to change an object into a hash but other times it doesn't (not sure when this actually happens), so I had to do two lines, one to change the hash into an object and then pop it into order_contents_as_objects or the item straight in.
  def session_cart_as_an_array_of_objects
    order_contents = []
    session[:shopping_cart_items].each do |order_content|
      if order_content.class == Hash
        order_contents << OrderContent.new(order_content)
      else
        order_contents << order_content
      end
    end
    order_contents
  end

  # Destroying order_content with a quantity less than 1 or if user has ticked the box to destroy.
  def store_or_destroy_product(order_content, index)
    if order_content.quantity < 1 || params["order_content_#{index}"]["_destroy"] == "1"
      order_content.destroy
    elsif order_content.persisted?
      order_content.save
    else
      session[:shopping_cart_items] << order_content
    end
  end
end