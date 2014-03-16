class Admin::ProductCustomTypesController < AdminController
  authorize_resource
  before_action :set_product_custom_type, except: [:index, :new, :create]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '手工包客製化種類管理', :admin_product_custom_types_path

  # GET /admin/product_custom_types
  # GET /admin/product_custom_types.json
  def index
    @product_custom_types = ProductCustomType.all
    @locales = Locale.all
  end

  # GET /admin/product_custom_types/1
  # GET /admin/product_custom_types/1.json
  def show

  end

  # GET /admin/product_custom_types/new
  def new
    add_breadcrumb '新增手工包客製化種類'

    @product_custom_type = ProductCustomType.new
    Locale.all.each do |locale|
      @product_custom_type.product_custom_type_translates.build(locale_id: locale.id)
    end
  end

  # GET /admin/product_custom_types/1/edit
  def edit
    add_breadcrumb '修改手工包客製化種類'
  end

  # POST /admin/product_custom_types
  # POST /admin/product_custom_types.json
  def create
    @product_custom_type = ProductCustomType.new(product_custom_type_params)

    respond_to do |format|
      if @product_custom_type.save
        format.html { redirect_to action: :index, notice: 'Create Success.' }
        format.json { render action: :index, status: :created }
      else
        format.html { render action: :new }
        format.json { render json: @product_custom_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/product_custom_types/1
  # PATCH/PUT /admin/product_custom_types/1.json
  def update
    respond_to do |format|
      if @product_custom_type.update_attributes(product_custom_type_params)
        format.html { redirect_to action: :index, notice: 'Update Success.' }
        format.json { render action: :index, status: :accepted }
      else
        format.html { render action: :edit }
        format.json { render json: @product_custom_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_custom_types/1
  # DELETE /admin/product_custom_types/1.json
  def destroy
    respond_to do |format|
      if @product_custom_type.destroy
        format.html { redirect_to action: :index }
      end
    end
  end

  private
    def set_product_custom_type
      @product_custom_type = ProductCustomType.find(params[:id])
    end

    def product_custom_type_params
      params.require(:product_custom_type).permit(:id, :multi, product_custom_type_translates_attributes: [:id, :name, :locale_id])
    end
end
