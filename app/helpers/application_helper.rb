module ApplicationHelper
  def error_messages_for(object, field=nil)
    errors = field ? object.errors[field] : object.errors.full_messages
    errors.each do |error|
      yield(error)
    end
  end

  def pagination_limit
    100
  end

  def pagination_range_start
    params[:page].to_i * pagination_limit
  end

  def pagination_range_end(resources)
    resources.length > (params[:page].to_i + 1) * pagination_limit ? pagination_range_start + pagination_limit : resources.length
  end

  def pagination_num_pages_for(resources)
    remainder_page = resources.length % pagination_limit == 0 ? 0 : 1
    (resources.length / pagination_limit + remainder_page)
  end

  def pagination_get_last_page_for(resources)
    pagination_num_pages_for(resources) - 1
  end

  def pagination_page_outside_range_link_for(resources)
    page = params[:page].to_i < 0 ? 0 : pagination_get_last_page_for(resources)
    link = link_to('these?', url_for(
      :controller => params[:controller],
      :action => 'index',
      :params => {:page => page}
    ))
    %Q{
      <p class="text-danger">
        Whoaa... paginated a bit too far huh? Perhaps you were looking for
        #{link}
      </p>
    }.html_safe
  end

  def pagination_offset
    params[:page] ? params[:page].to_i * pagination_limit : 0
  end

  def pagination_first_page?
    params[:page].to_i > 0
  end

  def pagination_last_page_for?(resources)
    params[:page].to_i < pagination_get_last_page_for(resources)
  end

  def pagination_page_outside_range_for?(resources)
    params[:page].to_i < 0 ||
    params[:page].to_i > pagination_get_last_page_for(resources)
  end
end
