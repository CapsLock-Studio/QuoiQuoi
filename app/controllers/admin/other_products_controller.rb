class Admin::OtherProductsController < AdminController
  authorize_resource :product

  before_action :set_product, except: [:index, :new, :create]
  before_action :delete_empty_product, except: [:update]

  # breadcrumbs
  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '商品列表', :admin_products_path

  # GET /products
  # GET /products.json
  def index
    # if filter is blank, set up default values.
    # at last, we need to covert array contents all to integer.
    @filter = (params[:filter] || ProductType.all.collect{|type| type.id}).collect{|filter| filter.to_i}
    @products = Product.where(product_type_id: @filter)
  end
  # GET /products/1
  # GET /products/1.json
  def show

  end
  # GET /products/new
  def new
    add_breadcrumb '新增商品'

    @product = Product.create
    Locale.all.each do |locale|
      @product.product_translates.create(locale_id: locale.id)
    end

    @product_type_options = get_product_type_options

    @article = @product
    @image_addition = ProductAdditionImage.new(product_id: @product.id)
  end
  # GET /products/1/edit
  def edit
    @product_type_options = get_product_type_options

    @article = @product
    @image_addition = ProductAdditionImage.new(product_id: @product.id)
  end

  def visible
    if @product.update_attribute(:visible, params[:visible])
      redirect_to action: :index
    else
      render json: @product.errors
    end
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
  def delete_empty_product
    Product.all.destroy_all(quantity: nil)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:id, :quantity, :image, :discount, :product_type_id,
                                    product_options_attributes: [:_destroy, :id, :content, :price, :locale_id],
                                    product_translates_attributes: [:id, :price, :name, :description, :locale_id],
                                    product_custom_items_attributes: [:_destroy, :id, :product_custom_type_id, :workday, :price, :image])
  end

  def get_product_type_options
    ProductType.all.collect do |product_type|
      ["#{product_type.id}. #{product_type.product_type_translates.collect{|translate| translate.name}.join(' / ')}", product_type.id]
    end
  end
end
