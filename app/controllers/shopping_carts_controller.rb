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
      # Destroying order_content with a quantity less than 1 or if user has ticked the box to destroy.
      # Saving order_content if it's previously persisted
      # Popping it in the session_shopping_cart if the object hasn't been persisted.
      if order_content.quantity < 1 || params["order_content_#{index}"]["_destroy"] == "1"
        order_content.destroy
      elsif order_content.persisted?
        order_content.save
      else
        session[:shopping_cart_items] << order_content
      end
    end
    if cart_is_empty?
      redirect_to shoppingcart_path
      flash[:notice] = "You ain't got no items in your blimey cart."
    else
      @order_contents = order_contents
      render :edit
      flash.now[:alert] = "Cart updated."
    end
  end

  private

  def cart_is_empty?
    !current_user && (session[:shopping_cart_items] == nil || session[:shopping_cart_items].size < 1)
  end

  # So first off I need to distinguish between whether this cart is pre or post sign_in...
  # If there is a current_user then we can just get that user's order where the checkout_date == nil .first .order_contents and send them in...
  # If there isn't we'll get the order contents from the sessions.
  def order_contents
    if current_user
      current_user.orders.where(:checkout_date => nil).first.order_contents
    else
      # The order contents in the session was coming out as a hash so I am changing them to objects before I send them in so that the view can just deal with the objects.
      order_contents_as_objects = []
      # Sometimes sessions seems to change an object into a hash but other times it doesn't (not sure when this actually happens), so I had to do two lines, one to change the hash into an object and then pop it into order_contents_as_objects or the item straight in.
      session[:shopping_cart_items].each do |order_content_as_hash|
        order_contents_as_objects << OrderContent.new(order_content_as_hash) if order_content_as_hash.class == Hash
        order_contents_as_objects << order_content_as_hash if order_content_as_hash.class == OrderContent
      end
      order_contents_as_objects
    end
  end
end