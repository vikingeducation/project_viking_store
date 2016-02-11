class Shop::SessionController < ShopController
  # This should render your sign-in form!
def new
  if session[:current_user_id]
    @user = User.find(session[:current_user_id])
  else
    @user = User.new
  end
end

# Sign in our user to create a new session
# in this case, we'll assume that the user has
# submitted their email address to sign in and
# that's it (no password checking).  This is
# obviously very simplistic and that's the idea
def create
  @user = User.find_by_email(user_params["email"])
  if @user
    sign_in @user
    flash[:success] = "Thanks for signing in!"
    redirect_to root_path
  else
    flash[:error] = "We couldn't sign you in due to errors."
    redirect_to new_shop_user_path
  end
end

# Sign out our user to destroy a session
def destroy
  if sign_out
    flash[:success] = "You have successfully signed out"
    redirect_to root_path
  else
    flash[:error] = "Angry robots have prevented you from signing out.  You're stuck here forever."
    redirect_to root_path
  end
end

private

def user_params
  params.require(:user).permit(:email)
end
end
