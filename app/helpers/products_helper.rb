module ProductsHelper
	def form_field_error_messages(resource, symbol)
		unless resource.errors[symbol].empty?
			"#{symbol.to_s.titleize} #{resource.errors[symbol].first}"
		end
	end
end
