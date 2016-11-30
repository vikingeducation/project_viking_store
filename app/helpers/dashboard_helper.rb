module DashboardHelper

  def name_parse(name_sym)
    name_sym.to_s.gsub("_", " ").titleize
  end
end
