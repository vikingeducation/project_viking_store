module StylesHelper

  def table_classes
    "table table-striped table-hover table-sm table-bordered"
  end

  def column_classes
    "col-lg-6"
  end

  def button_classes(style = 'primary')
    "btn btn-sm btn-#{style}"
  end

end
