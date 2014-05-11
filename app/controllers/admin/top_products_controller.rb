class Admin::TopProductsController < ApplicationController
  authorize_resource

  before_action :set_top_product, except: [:index, :new, :create, :sort]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '首頁選定列表', :admin_top_products_path

  # GET /admin/top_products
  def index
    @top_products = TopProduct.order(:sort)
  end

  # GET /admin/top_products/new
  def new
    add_breadcrumb '新增首頁選定'

    @top_product = TopProduct.new
  end

  # GET /admin/top_products/edit
  def edit
    add_breadcrumb '修改首頁選定'

  end

  # POST /admin/top_products
  def create
    params = top_product_params.merge(sort: 1)

    top_products = TopProduct.order(:sort)

    unless top_products.last.nil?
      params[:sort] = (top_products.last.sort.to_i + 1)
    end

    @top_product = TopProduct.new(params)

    respond_to do |format|
      #format.html {render json: params}
      if @top_product.save
        format.html {redirect_to action: :index, notice: 'Create Success.'}
      else
        format.html {render action: :new}
      end
    end
  end

  # PUT/PATCH /admin/top_products/1
  def update
    respond_to do |format|
      if @top_product.update(top_product_params)
        format.html {redirect_to action: :index}
      else
        format.html {render action: :edit}
      end
    end
  end

  # DELETE /admin/top_products/1
  def destroy
    respond_to do |format|
      if @top_product.destroy
        format.html {redirect_to action: :index}
      end
    end
  end

  # PUT /admin/top_products/sort
  def sort
    respond_to do |format|
      #format.html {render json: update_params}
      top_products = TopProduct.update(update_params[:top_products].keys, update_params[:top_products].values).reject{|p| p.errors.empty?}
      if top_products.empty?
        format.html {redirect_to action: :index, sorted: true}
      end
    end
  end

  private
  def top_product_params
    params.require(:top_product).permit(:id, :link, :image, :sort, :top_product_position_id,
                                  top_product_translates_attributes: [:id, :locale_id, :title, :description])
  end

  def set_top_product
    @top_product = TopProduct.find(params[:id])
  end

  def update_params
    params.permit(top_products: [:id, :sort])
  end
end
