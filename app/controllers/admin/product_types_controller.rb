class Admin::ProductTypesController < AdminController
  authorize_resource
  before_action :set_product_type, except: [:index, :new, :create]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '其他商品種類管理', :admin_product_types_path

  # GET /admin/product_types
  # GET /admin/product_types.json
  def index
    @product_types = ProductType.all
    @locales = Locale.all
  end

  # GET /admin/product_types/1
  # GET /admin/product_types/1.json
  def show

  end

  # GET /admin/product_types/new
  def new
    add_breadcrumb '新增其他商品種類'

    @product_type = ProductType.new
    Locale.all.each do |locale|
      @product_type.product_type_translates.build(locale_id: locale.id)
    end
  end

  # GET /admin/product_types/1/edit
  def edit
    add_breadcrumb '修改其他商品種類'
  end

  # POST /admin/product_types
  # POST /admin/product_types.json
  def create
    @product_type = ProductType.new(product_type_params)

    respond_to do |format|
      if @product_type.save
        format.html { redirect_to action: :index, notice: 'Create Success.' }
        format.json { render action: :index, status: :created }
      else
        format.html { render action: :new }
        format.json { render json: @product_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/product_types/1
  # PATCH/PUT /admin/product_types/1.json
  def update
    respond_to do |format|
      if @product_type.update_attributes(product_type_params)
        format.html { redirect_to action: :index, notice: 'Update Success.' }
        format.json { render action: :index, status: :accepted }
      else
        format.html { render action: :edit }
        format.json { render json: @product_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_types/1
  # DELETE /admin/product_types/1.json
  def destroy
    respond_to do |format|
      if @product_type.destroy
        format.html { redirect_to action: :index }
      end
    end
  end

  private
  def set_product_type
    @product_type = ProductType.find(params[:id])
  end

  def product_type_params
    params.require(:product_type).permit(:id, product_type_translates_attributes: [:id, :name, :locale_id])
  end
end
