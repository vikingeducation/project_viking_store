module Admin::AddressesHelper

  def address_create(user)

    if user
      link_to "Create a #{user.first_name} #{user.last_name} Address", new_admin_address_path(:user_id => user.id), class: 'btn btn-success btn-lg btn block'
    else
      render 'admin/shared/point_to_users_index'
    end

  end
  
end
