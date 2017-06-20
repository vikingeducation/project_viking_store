module AddressesHelper
  def secondary_address(address)
    address.secondary_address ? ", #{address.secondary_address}" : ""
  end

  def name(user)
    "#{address.user.first_name} #{address.user.last_name}"
  end

  def index_address_create(user)
    if user
      (link_to "Create Address for #{user.name}", new_admin_user_address_path(user), :class => "btn btn-block btn-default btn-lg btn-primary")
    else
      raw("<em>Create new addresses from within #{(link_to 'User', admin_users_path)} profiles </em>")
    end
  end
end
