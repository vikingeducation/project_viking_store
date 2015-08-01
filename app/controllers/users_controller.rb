class UsersController < ApplicationController
  before_action :require_login, exclude: [:new, :create]
  before_action :require_current_user, only: [:edit, :update, :destroy]


  def new
    @user = User.new
    2.times do
      @user.addresses.build
    end
  end

  def create
    @user = User.new(whitelisted_user_params)
    #result = begin_user_address_transaction
    if @user.save
      set_addresses(@user)
      flash[:success] = "You've successfully signed up! Congratulations!"
      sign_in @user
      @user.merge_carts(session[:cart])
      session[:cart] = []
      redirect_to root_path
    else
      flash[:danger] = "There was an error saving your user."
      binding.pry
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    @user.addresses.build
  end

  def update
    @user = User.find(params[:id])
    if @user == current_user && @user.update(whitelisted_user_params)
      flash[:success] = "You've successfully updated your profile!"
      redirect_to root_path
    else
      flash[:danger] = "There was an error updating your profile."
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user == current_user && @user.destroy
      sign_out
      flash[:success] = "You've successfully deleted your account.\
      Thanks for shopping with us."
      redirect_to root_path
    else
      flash[:danger] = "There was an error deleting your profile."
      render root_path
    end
  end

  private
    def whitelisted_user_params
      params.require(:user).permit(:email, :email_confirmation,
                                   :first_name, :last_name,
                                   :shipping_id,
                                   :billing_id,
                                   {addresses_attributes: [:id,
                                                           :street_address,
                                                           :zip_code,
                                                           :city_id,
                                                           :state_id]})
    end

    def require_current_user
      unless current_user == User.find(params[:id])
        flash[:danger] = "You do not have access to that page."
        redirect_to root_url
      end
    end

    def set_addresses(user)
      if params[:billing_address]
        user.billing_id = get_initial_billing(user)
      end

      if params[:shipping_address]
        user.shipping_id = get_initial_shipping(user)
      end

      user.save
    end

    def get_initial_billing(user)
      if user.addresses.where(street_address: params[:user][:addresses_attributes][params[:billing_address]][:street_address]).first
        user.addresses.where(street_address: params[:user][:addresses_attributes][params[:billing_address]][:street_address]).first.id
      end
    end

    def get_initial_shipping(user)
      if user.addresses.where(street_address: params[:user][:addresses_attributes][params[:shipping_address]][:street_address]).first
        user.addresses.where(street_address: params[:user][:addresses_attributes][params[:shipping_address]][:street_address]).first.id
      end
    end
end
