class OrderContentsController < ApplicationController

  def update_quantities
    if OrderContent.update(update_params.keys, update_params.values)
      flash[:success]= "You updates the quantities of the order"
      redirect_to user_order_path(User.find(params[:user_id]), Order.find(params[:order_id]))
    else
      flash[:danger]= "Something went wrong"
      redirect_to(:back)
    end
  end

  def update_products
    order = Order.find(params[:order_id])

    params[:product].each do |nb, product|
      unless product[:id].nil?
        if product[:quantity].to_i >= 0
          if Product.exists?(product[:id])
            if order.products.ids.include? product[:id].to_i
              OrderContent.where(product_id: product[:id].to_i).first.update_attributes(quantity: ( OrderContent.where(product_id: product[:id].to_i).first.quantity + product[:quantity].to_i) )
            else
              OrderContent.create(product_id: product[:id].to_i, quantity: product[:quantity].to_i, order_id: params[:order_id].to_i)
            end
          end
        end
      end
    end
    redirect_to user_order_path(User.find(params[:user_id]), Order.find(params[:order_id]))
  end


  def destroy
    @order_content = OrderContent.find(params[:id])
    if @order_content.destroy
      flash[:success] = "you delete that product"
    else
      flash[:danger] = "Something went wrong"
    end
    redirect_to(:back)
  end

  private

  def update_params
    params.require(:order_content)
  end
end
