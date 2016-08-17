module OrdersHelper
  def render_status(status)
    if status == "PLACED"
      html = "<span id='placed'>PLACED</span>"
    else
      html = "<span id='unplaced'>UNPLACED</span>"
    end

    html.html_safe
  end
end
