class Admin::OtherProductsController < AdminController
  authorize_resource :product

  before_action :set_product, except: [:index, :new, :create]

  # breadcrumbs
  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '商品列表', :admin_products_path

  # GET /products
  # GET /products.json
  def index
    @products = Product.where.not(product_type_id: nil)
  end
  # GET /products/1
  # GET /products/1.json
  def show

  end
  # GET /products/new
  def new
    add_breadcrumb '新增商品'

    @product = Product.new
    @locales = Locale.all
    @locales.each do |locale|
      @product.product_translates.build(locale_id: locale.id)
    end

  end
  # GET /products/1/edit
  def edit
    @locales = Locale.all
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        format.html {redirect_to action: :index, notice: 'Create Success.'}
      else
        format.html {render action: :new}
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html {redirect_to action: :index, notice: 'Update Success.'}
      else
        format.html {render action: :edit}
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
  end

  private
  def set_product
    @product = Product.find(params[:id])
  end
  def product_params
    params.require(:product).permit(:id, :price, :quantity, :image, product_translates_attributes: [:id, :name, :description, :locale_id],
                                    product_custom_items_attributes: [:_destroy, :id, :product_custom_type_id, :workday, :price, :image,
                                                                      product_custom_item_translates_attributes: [:id, :name, :locale_id
                                                                      ]
                                    ])
  end
end
