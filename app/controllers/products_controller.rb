class ProductsController < ApplicationController
  before_action :set_product, except: [:index, :search]

  # GET /products
  # GET /products.json
  def index
    flash[:message] = nil

    respond_to do |format|
      format.html do
        add_breadcrumb t('home'), :root_path

        @products = Product.where(product_type_id: params[:product_type_id]).order(id: :desc).page(params[:page]).per(12)

        unless @products.first.nil?
          add_breadcrumb @products.first.product_type_id.nil? ? I18n.t('handmadebag') : @products.first.product_type.product_type_translates.where(locale_id: session[:locale_id]).first.name.upcase
        end
      end

      format.xml do
        @products = Product.order(created_at: :desc).limit(50)

        render template: 'products/index.atom.builder', layout: false
      end
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    add_breadcrumb t('home'), :root_path
    if @product.product_type_id.nil?
      add_breadcrumb t('handmadebag'), products_path
    else
      add_breadcrumb @product.product_type.product_type_translates.where(locale_id: session[:locale_id]).first.name
    end
    add_breadcrumb t('detail')

    @order_product = OrderProduct.new(product_id: @product.id)
    @other_products = Product.where(product_type_id: @product.product_type_id).order(id: :desc).limit(8)

    #set seo meta
    translate = @product.product_translates.where(locale_id: session[:locale_id]).first

    unless translate.price
      render json: 'this product is not available in this locale setting'
    end

    @meta_og_title = translate.name
    @meta_og_description = translate.description.gsub(/\n/, '')
    @meta_og_type = 'product'
    @meta_og_image = "http://quoiquoi.tw#{@product.image.url(:large)}"
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
