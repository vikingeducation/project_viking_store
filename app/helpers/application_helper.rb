module ApplicationHelper

  def present_data(data)

    unless data.is_a?(Array)
      [data]
    else
      data
    end

  end

  def currency_if_float(input)

    input.is_a?(Float) ? number_to_currency(input) : input

  end
  
end
