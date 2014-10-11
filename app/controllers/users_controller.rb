class UsersController < ApplicationController


    def index
      @users = User.all
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(whitelisted_params)

      if @user.save
        flash[:success] = "New user saved."
        redirect_to action: :index
      else
        flash.now[:error] = "Something was invalid."
        render :new
      end
    end

    def show
      @user = User.find(params[:id])

      @user_orders_value = User.order_values
    end

    def edit
      @user = User.find(params[:id])

    end

    def update
      @user = User.find(params[:id])

      if @user.update(whitelisted_params)
        flash[:success] = "Updated!"
        redirect_to action: :index
      else
        flash.now[:error] = "Something went wrong."
        render :edit
      end
    end

    def destroy
      session[:return_to] ||= request.referer
      if User.find(params[:id]).destroy
        flash[:success] = "Deleted."
        redirect_to action: :index
      else
        flash[:error] = "Something went wrong in that deletion."
        redirect_to session.delete[:return_to]
      end
    end

  private

    def whitelisted_params
      params.require(:user).permit(:first_name, :last_name,
                                   :email, :billing_id, :shipping_id)
    end

    #takes a string parameter
    def clean_price(input)
      input[0] == "$" ? input[1..-1].to_f : input.to_f
    end



end
