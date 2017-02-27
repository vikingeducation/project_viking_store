class Admin::ProductsController < ApplicationController
  layout 'admin'
  def index
    @products = Product.all.order('id')
    render  locals: { rows: @products, headings: ['id', 'name', 'description']}
  end
end
