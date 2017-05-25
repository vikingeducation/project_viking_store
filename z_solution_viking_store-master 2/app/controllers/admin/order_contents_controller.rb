class Admin::OrderContentsController < AdminController
	def create
    if Purchase.create(create_purchase_params.values)
      flash[:success] = "New contents added to order."
      redirect_to orders_path
    else
      flash.now[:error] = "Failed to add order contents."
      render :index # not sure about this one
    end
  end

  def update
    if Purchase.update(update_purchase_params.keys, update_purchase_params.values)
      flash[:success] = "Order contents updated."
      redirect_to orders_path
    else
      flash.now[:error] = "Order contents failed to update."
      render :index # not sure about this one
    end
  end

  def destroy
  end

  private

  def update_purchase_params
    params.require(:purchases)
  end

end


