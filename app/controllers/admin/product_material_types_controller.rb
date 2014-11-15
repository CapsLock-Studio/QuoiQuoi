class Admin::ProductMaterialTypesController < AdminController
  authorize_resource
  before_action :set_product, only: [:index, :new]
  before_action :set_product_material_type, only: [:edit, :update, :destroy, :collapsed, :visible]

  def index

  end

  def new
    @product_material_type = ProductMaterialType.new(product_id: @product.id)

    if !params[:new].nil? && params[:new]
      @product_material_type.build_material_type
      Locale.all.order(:id).each do |locale|
        @product_material_type.material_type.material_type_translates.build(locale_id: locale.id)
      end
    else
      already_exists_material_types = ProductMaterialType.where(product_id: @product.id).collect do |product_material_type|
        product_material_type.material_type
      end
      @material_types = MaterialType.where.not(id: already_exists_material_types).order(:id)
      render 'pickup'
    end
  end

  def edit
    @product = @product_material_type.product
    render 'new'
  end

  def create
    @product_material_type = ProductMaterialType.new(product_material_type_params)

    if @product_material_type.save
      redirect_to admin_product_product_material_types_path(@product_material_type.product)
    else
      render json: @product_material_type.errors
    end
  end

  def update

  end

  def collapsed
    if @product_material_type.update_attribute(:collapsed, params[:collapsed])
      redirect_to :back
    else
      render json: @product_material_type.errors
    end
  end

  def visible
    if @product_material_type.update_attribute(:visible, params[:visible])
      redirect_to :back
    else
      render json: @product_material_type.errors
    end
  end

  def destroy
    if @product_material_type.destroy
      redirect_to :back
    else
      render json: @product_material_type.errors
    end
  end

  private
  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_product_material_type
    @product_material_type = ProductMaterialType.find(params[:id])
  end

  def product_material_type_params
    params.require(:product_material_type).permit(:product_id, :material_type_id, material_type_attributes: [
        :all, material_type_translates_attributes: [:name, :locale_id]
    ])
  end
end