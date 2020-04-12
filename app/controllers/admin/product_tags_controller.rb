class Admin::ProductTagsController < AdminController
  before_action :set_product_tag, except: [:index, :new, :create, :sort]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '商品管理', :admin_products_path
  add_breadcrumb '商品標籤管理', :admin_product_tags_path

  # GET /admin/product_tags
  # GET /admin/product_tags.json
  def index
    @product_tags = ProductTag.all.order(:sort)
    @locales = Locale.all
  end

  # GET /admin/product_tags/1
  # GET /admin/product_tags/1.json
  def show

  end

  # GET /admin/product_tags/new
  def new
    add_breadcrumb '新增商品標籤'

    @product_tag = ProductTag.new
    Locale.all.each do |locale|
      @product_tag.product_tag_translates.build(locale_id: locale.id)
    end
  end

  # GET /admin/product_tags/1/edit
  def edit
    add_breadcrumb '修改商品標籤'
  end

  # POST /admin/product_tags
  # POST /admin/product_tags.json
  def create
    @product_tag = ProductTag.new(product_tag_params)

    respond_to do |format|
      if @product_tag.save
        format.html { redirect_to action: :index, notice: 'Create Success.' }
        format.json { render action: :index, status: :created }
      else
        format.html { render action: :new }
        format.json { render json: @product_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/product_tags/1
  # PATCH/PUT /admin/product_tags/1.json
  def update
    respond_to do |format|
      if @product_tag.update_attributes(product_tag_params)
        format.html { redirect_to action: :index, notice: 'Update Success.' }
        format.json { render action: :index, status: :accepted }
      else
        format.html { render action: :edit }
        format.json { render json: @product_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_tags/1
  # DELETE /admin/product_tags/1.json
  def destroy
    respond_to do |format|
      if @product_tag.destroy
        format.html { redirect_to action: :index }
      end
    end
  end

  def sort
    if ProductTag.update(sort_update_params[:product_tags].keys, sort_update_params[:product_tags].values)
      redirect_to :back, flash: {sorted: true}
    else
      render json: [message: 'Update Failed.']
    end
  end

  private
  def set_product_tag
    @product_tag = ProductTag.find(params[:id])
  end

  def product_tag_params
    params.require(:product_tag).permit(:id, :thumbnail, :image, product_tag_translates_attributes: [:id, :name, :locale_id])
  end

  def sort_update_params
    params.permit(product_tags: [:id, :sort])
  end
end
