class UsersController < ApplicationController
  def new
    @user = User.new
    2.times do
      @user.addresses.build
    end
  end

  def create
    if @user = User.create(whitelisted_user_params)
      @user.rebuild_user_addresses(params[:address])
      flash[:success] = "You've successfully signed up! Congratulations!"
      sign_in @user
      @user.merge_carts(session[:cart])
      session[:cart] = []
      redirect_to root_path
    else
      flash[:danger] = "There are issues in your form, please try again."
      render :new
    end
  end

  private
    def whitelisted_user_params
      params.require(:user).permit(:email, :email_confirmation,
                                   :first_name, :last_name,
                                   :shipping_id,
                                   :billing_id,
                                   address: [])
    end
end
