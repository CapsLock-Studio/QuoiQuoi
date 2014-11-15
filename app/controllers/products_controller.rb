class ProductsController < ApplicationController
  before_action :set_product, except: [:index, :search]
  before_action :set_product_type, only: [:index]

  # GET /products
  # GET /products.json
  def index
    flash[:message] = nil

    respond_to do |format|
      format.html do
        add_breadcrumb t('home'), :root_path

        @products = get_products

        if params[:product_type_id]
          product_type_name = ProductType.find(params[:product_type_id]).product_type_translates.find_by_locale_id(session[:locale_id]).name
        else
          product_type_name = I18n.t('handmadebag')
        end

        add_breadcrumb product_type_name

        # append to title name for seo
        @website_title = "#{product_type_name} | #{@website_title}"
      end

      format.json do
        helpers = ApplicationController.helpers
        products = get_products

        render(
            json:
                {
                    items: products.collect do |product|
                      [
                          {
                              key: 'url',
                              value: polymorphic_path([@product_type, product])
                          },
                          {
                              key: 'name',
                              value: helpers.truncate(product.product_translate.name, length: (session[:locale] == 'en')? 38 : 20)
                          },
                          {
                              key: 'image',
                              value: product.image.url(:small)
                          },
                          {
                              key: 'price',
                              value: helpers.number_to_currency(helpers.price_discount(product.product_translate.price, product.discount))
                          },
                          {
                              key: 'discount',
                              value: t('product.discount', percent: helpers.locale_discount(product.discount, session[:locale_id]))
                          },
                          {
                              key: 'visible',
                              value: (product.discount > 0)? '' : 'hidden'
                          }
                      ]
                    end,
                    nextPage: (products.total_pages > products.current_page) ? polymorphic_path([@product_type, :products], page: ((params[:page] || 1).to_i + 1), format: :json) : nil
                }
        )
      end

      format.xml do
        @products = Product.includes(:product_translate)
                           .where(product_translates: {locale_id: session[:locale_id]},
                                  visible: true)
                           .where.not(product_translates: {name: '', description: '', price: nil})
                           .order(id: :desc).limit(50)

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
      add_breadcrumb ProductTypeTranslate.find_by_locale_id_and_product_type_id(session[:locale_id], params[:product_type_id]).name, product_type_products_path(@product.product_type_id)
    end

    #set seo meta
    translate = @product.product_translates.find_by_locale_id(session[:locale_id])
    add_breadcrumb translate.name

    unless translate.price
      render json: 'this product is not available in this locale setting'
    end

    @website_title = "#{translate.name} | #{@website_title}"
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
      @product = Product.includes(:product_translate)
                        .where(product_translates: {locale_id: session[:locale_id]})
                        .find(params[:id])
    end

    def set_product_type
      @product_type = ProductType.find_by_id(params[:product_type_id])
    end

    def get_products
      Product.includes(:product_translate)
             .where(product_type_id: params[:product_type_id],
                    product_translates: {locale_id: session[:locale_id]},
                    visible: true)
             .where.not(product_translates: {name: '', description: '', price: nil})
             .order(id: :desc)
             .page(params[:page]).per(24)
    end
end
