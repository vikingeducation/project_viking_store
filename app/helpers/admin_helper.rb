module AdminHelper

  def show_as_price(value)
    number_with_precision(value, precision: 2, delimiter: ",")
  end
end
