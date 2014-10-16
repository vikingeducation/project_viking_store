class Admin::PurchasesController < AdminController

    def index
      @purchases = Purchase.all
    end

    def new
      @purchase = Purchase.new
    end

    def create
      @purchase = Purchase.new(whitelisted_params)

      if @purchase.save
        flash[:success] = "New purchase saved."
        redirect_to action: :index
      else
        flash.now[:error] = "Something was invalid."
        render :new
      end
    end

    def show
      @purchase = Purchase.find(params[:id])

      @purchase_numorders = @purchase.orders.count
      @purchase_numcarts = @purchase.orders.where(:checked_out => false).count
    end

    def edit
      @purchase = Purchase.find(params[:id])

    end

    def update
      @purchase = Purchase.find(params[:id])

      if @purchase.update(whitelisted_params)
        flash[:success] = "Updated!"
        redirect_to action: :index
      else
        flash.now[:error] = "Something went wrong."
        render :edit
      end
    end

    def destroy
      @order = Order.find(params[:order_id])
      @user = User.find(@order.user_id)

      session[:return_to] ||= request.referer
      if Purchase.find(params[:id]).destroy
        flash[:success] = "Deleted."
        redirect_to admin_edit_user_order_path(@user, @order)
      else
        flash[:error] = "Something went wrong in that deletion."
        redirect_to session.delete(:return_to)
      end
    end

  private

    def whitelisted_params
      params.require(:purchase).permit(:order_id, :product_id, :quantity)
    end

    #takes a string parameter
    def clean_price(input)
      input[0] == "$" ? input[1..-1].to_f : input.to_f
    end



end
