module OrdersHelper

  def create_from_index(user)
    if user
      link_to "Create an Order for #{user.first_name} #{user.last_name}",
        new_order_path(:user_id => user.id),
        class: 'btn btn-primary btn-lg btn-block'
    else
      render 'shared/point_to_users_index'
    end
  end

end
