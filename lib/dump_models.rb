module DumpModels
  
  def pp_models
    models_table = []

    Hirb.enable
    Rails.application.eager_load!
    ActiveRecord::Base.descendants.each do |model|
      row = [model.to_s.pluralize]
      row << model.to_s.constantize.column_names
      models_table << row
    end
    
    puts Hirb::Helpers::AutoTable.render(models_table)
  end

end