class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # I'm just gonna write all of this out from the lessons for muscle memory...
  # "sign in" a user by storing its ID in the 'params' hash
  # and setting that user to the 'current_user' (See below)
  def sign_in(user)
    session[:current_user_id] = user.id
    current_user = user
  end

  # "sign out" by removing the ID and deleting the current_user
  def sign_out
    session.delete(:current_user_id)
    current_user = nil
    session[:current_user_id].nil? && current_user.nil?
  end

  # set the current user by either pulling from the 
  # database based on what we've got saved in the
  # session or just using the one that was already set
  # in the instance variable from last time (to avoid
  # an extra database call)
  # eject if we don't have one specified in the session
  def current_user
    return nil unless session[:current_user_id]
    @current_user ||= User.find(session[:current_user_id])
  end
  helper_method :current_user

  # set the '@current_user' instance variable so we won't
  # always have the re-query the database when returning
  # the current user with the 'current_user' method above
  def current_user=(user)
    @current_user = user
  end

  # This is better than having a method in the order model because this can be used for session items where there is no order yet.
  def order_total(order_contents)
    total = 0
    order_contents.each do |order_content|
      total += (order_content.quantity * order_content.product.price)
    end
    total
  end

  # check the general case that there is *someone*
  # currently signed in.
  # !! allows this to return a boolean instead of
  # an object or 'nil'. If there is an object for the
  # current_user, it returns 'true'. Try it on the CLI.
  def signed_in_user?
    !!current_user
  end
  helper_method :signed_in_user?

end
