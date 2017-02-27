class Admin::ProductsController < ApplicationController
    layout 'admin'
    def index
        @products = Product.find_by_sql 'SELECT products.id as id, products.price AS price, products.name AS name, categories.name AS category, categories.id AS category_id FROM products LEFT OUTER JOIN categories on categories.id = products.category_id'
        render locals: { rows: @products, headings: %w(id name price category) }
    end

    def new
        @product = Product.new
    end

    def show
        @product = Product.find(params[:id])
    end

    def edit
        @product = Product.find(params[:id])
    end

    def update
        @product = Product.find(params[:id])
        if @product.update(whitelisted_product_params)
            flash[:success] = 'Success! Your product has been updated'
            redirect_to admin_product_path(@product)
        else
            flash[:error] = "We couldn't update the product. Please check the form for errors!"
            render :edit
        end
    end

    def create
        wp = whitelisted_product_params
        wp[:price] = wp[:price].gsub('\$', '')
        @product = Product.new(wp)

        # check that category is valid and real
        if @product.save
            flash[:success] = 'Success! Your product was created'
            redirect_to admin_product_path(@product)
        else
            flash.now[:error] = "Sorry, we couldn't create your product. Please go over your form inputs"
            render :new
        end
    end

    def destroy
        @product = Product.find(params[:id])
        if @product.delete
            flash[:success] = 'Success! Your product was deleted'
        else
            flash[:error] = "Sorry, that product can't be deleted"
        end
        redirect_to admin_products_path
    end

    private

    def whitelisted_product_params
        params.require(:product).permit(:name, :price, :category_id, :description, :sku)
    end
end
