module ApplicationHelper
  def form_errors(resource)
    return if resource.errors.empty?

    content_tag 'div', class: %w(ui error message) do
      content_tag('i', nil, class: %(close icon)) +
      content_tag( 'div', class: 'header') do
        "There were some errors with your submission"
      end +

      content_tag('ul', class: 'list') do
        resource.errors.full_messages.map do |message|
          content_tag('li', message)
        end.join.html_safe
      end
    end
  end
end
