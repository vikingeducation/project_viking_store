module AdminHelper
  def categories_as_options
    Category.find_each.map { |cat| [cat.name, cat.id] }.unshift(['Select a Category', ''])
  end


end
