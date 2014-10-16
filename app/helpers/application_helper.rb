module ApplicationHelper


 def sign_in(user)
   session[:current_user_id] = user.id
   current_user = user
 end
 
 def sign_out(user)
   session.delete(:current_user_id) && current_user = nil
 end
 


 #deprecated in favor of model method now included in Address.rb
  def full_address(address)
    if address
      "#{address.street_address}#{address.secondary_address}, #{address.city}, #{address.state} #{address.zip}"
    else
      "N/A"
    end
  end
  
  
  private
  
  def current_user
    return nil unless session[:current_user_id]
    @current_user ||= User.find(session[:current_user_id])
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  # returns true/false that user is signed in or not.
  def user_signed_in?
    !!@current_user
  end
end
