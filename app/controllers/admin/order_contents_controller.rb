class Admin::OrderContentsController < AdminController

  def update_quantities
    if OrderContent.update(update_params.keys, update_params.values)
      flash[:success]= "You updates the quantities of the order"
      redirect_to admin_user_order_path(User.find(params[:user_id]), Order.find(params[:order_id]))
    else
      flash[:danger]= "Something went wrong"
      redirect_to(:back)
    end
  end

  def update_products
    order = Order.find(params[:order_id])

    params[:product].each do |nb, product|
      product_id = product[:id].to_i
      quantity = product[:quantity].to_i

      if !product_id.nil?
        if quantity >= 0
          if Product.exists?(product_id)
            if order.products.ids.include? product_id
              order.order_contents.where(product_id: product_id).first.update_attributes(quantity: ( order.order_contents.where(product_id: product[:id]).first.quantity + quantity) )
            else
              o = order.order_contents.build(product_id: product_id, quantity: quantity)
              o.save
            end
          end
        end
      end
    end
    redirect_to admin_user_order_path(User.find(params[:user_id]), Order.find(params[:order_id]))
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
