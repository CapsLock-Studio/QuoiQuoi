class ProductsController < ApplicationController
  before_action :set_product, except: [:index]

  # GET /products
  # GET /products.json
  def index
    add_breadcrumb t('header.navigation.home'), :root_path

    @products = Product.where(product_type_id: params[:product_type_id]).page(params[:page]).per(12)

    unless @products.first.nil?
      add_breadcrumb @products.first.product_type_id.nil? ? I18n.t('header.navigation.handmadebag') : @products.first.product_type.product_type_translates.where(locale_id: session[:locale_id]).first.name.upcase
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    add_breadcrumb t('header.navigation.home'), :root_path
    if @product.product_type_id.nil?
      add_breadcrumb t('header.navigation.handmadebag'), products_path
    else
      add_breadcrumb @product.product_type.product_type_translates.where(locale_id: session[:locale_id]).first.name.upcase
    end
    add_breadcrumb t('product_detail')

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

    def set_product
      @product = Product.find(params[:id])
    end
end
