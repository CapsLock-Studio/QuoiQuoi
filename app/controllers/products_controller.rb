class ProductsController < ApplicationController
  before_action :set_product, except: [:index]

  # GET /products
  # GET /products.json
  def index
    set_breadcrumbs

    @products = Product.where(product_type_id: params[:product_type_id]).page(params[:page]).per(12)

    unless @products.first.nil?
      add_breadcrumb @products.first.product_type_id.nil? ? I18n.t('header.navigation.handmadebag') : @products.first.product_type.product_type_translates.where(locale_id: session[:locale_id]).first.name.upcase
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    set_breadcrumbs
    add_breadcrumb @product.product_type_id.nil? ? I18n.t('header.navigation.handmadebag') : @product.product_type.product_type_translates.where(locale_id: session[:locale_id]).first.name.upcase

    @product_custom_types = ProductCustomType.select(:id, :multi)

    @order_product = OrderProduct.new(product_id: @product.id)
  end

  # GET /products/new
  def new

  end

  # GET /products/edit
  def edit

  end

  # POST /products
  # POST /products.json
  def create

  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update

  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy

  end

  private
    def set_breadcrumbs
      add_breadcrumb I18n.t('header.navigation.home'), :root_path
      add_breadcrumb I18n.t('header.navigation.shop'), :products_path
    end

    def set_product
      @product = Product.find(params[:id])
    end
end
