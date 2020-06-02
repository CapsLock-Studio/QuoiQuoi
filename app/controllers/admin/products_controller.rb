class Admin::ProductsController < AdminController
  authorize_resource

  before_action :set_product, except: [:index, :new, :create]
  before_action :delete_empty_product, except: [:create, :update]

  # breadcrumbs
  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '商品列表', :admin_products_path

  # GET /products
  # GET /products.json
  def index
    @product_tags = ProductTag.all
    @selected_tag_ids = params[:selected_tag_ids].nil? ? nil : params[:selected_tag_ids].split(',').map {|id| id.to_i}
    @products = @selected_tag_ids.nil? ? Product.where(product_type_id: nil) : Product.includes(:product_tags).where(product_tags: { id: @selected_tag_ids })
  end
  # GET /products/1
  # GET /products/1.json
  def show

  end
  # GET /products/new
  def new
    add_breadcrumb '新增商品'

    @product = Product.create
    @locales = Locale.all.order(id: :desc)
    @locales.each do |locale|
      @product.product_translates.create(locale_id: locale.id)
    end

    @article = @product
    @image_addition = ProductAdditionImage.new(product_id: @product.id)
    @product_tags = ProductTag.all
  end
  # GET /products/1/edit
  def edit
    @locales = Locale.all.order(id: :desc)

    @article = @product
    @image_addition = ProductAdditionImage.new(product_id: @product.id)
    @product_tags = ProductTag.all
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

    unless @product.product_type_id.nil?
      controller = :other_products
    end

    respond_to do |format|
      if @product.save
        format.html {redirect_to controller: controller ||= params[:controller], action: :index, notice: 'Create Success.'}
      else
        format.html {render controller: controller ||= params[:controller], action: :new}
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    unless @product.product_type_id.nil?
      controller = :other_products
    end

    respond_to do |format|
      if @product.update(product_params)
        format.html {redirect_to controller: controller ||= params[:controller], action: :index, notice: 'Update Success.'}
      else
        format.html {render controller: controller ||= params[:controller], action: :edit}
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    unless @product.product_type_id.nil?
      controller = :other_products
    end

    respond_to do |format|
      if @product.destroy
        format.html {redirect_to controller: controller ||= params[:controller], action: :index}
      end
    end
  end

  private
  def set_product
    @product = Product.includes(:product_tags).find(params[:id])
  end

  def product_params
    value = params.require(:product).permit(:id, :image, :product_type_id, :quantity, :discount,
                                    product_youtubes_attributes: [:_destroy, :id, :link],
                                    product_images_attributes: [:_destroy, :id, :image],
                                    product_options_attributes: [:_destroy, :id, :content, :price, :locale_id],
                                    product_translates_attributes: [:id, :price, :name, :description, :locale_id],
                                    product_custom_items_attributes: [:_destroy, :id, :product_custom_type_id, :workday, :price, :image,
                                                                      product_custom_item_translates_attributes: [:id, :name, :locale_id
                                                                      ]
                                    ])

    selected_product_tags = (params[:product_tag_ids] || '').split(',').map{|tag| ProductTag.find_by_id(tag.to_i)}.select{|tag| !tag.nil?}

    value[:product_tags] = selected_product_tags

    value
  end

  def delete_empty_product
    Product.all.destroy_all(quantity: nil)
  end
end
