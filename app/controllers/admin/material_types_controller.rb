class Admin::MaterialTypesController < AdminController
  authorize_resource :material
  before_action :set_material_type, only: [:edit, :update, :visible, :collapsed, :all, :destroy]
  before_action :set_material_types, only: [:index, :edit]

  def index
  end

  def new
    @material_type = MaterialType.new

    Locale.all.order(:id).each do |locale|
      @material_type.material_type_translates.build(locale_id: locale.id)
    end
  end

  def edit
    render :new
  end

  def create
    @material_type = MaterialType.new(material_type_params)

    if @material_type.save
      redirect_to admin_material_types_path
    else
      render json: @material_type.errors
    end
  end

  def update
    if @material_type.update_attributes(material_type_params)
      redirect_to action: :index
    else
      render json: @material_type.errors
    end
  end

  def visible
    if @material_type.update_attribute(:visible, params[:visible])
      redirect_to action: :index
    else
      render json: @material_type.errors
    end
  end

  def collapsed
    if @material_type.update_attribute(:collapsed, params[:collapsed])
      redirect_to action: :index
    else
      render json: @material_type.errors
    end
  end

  def all
    if @material_type.update_attribute(:all, params[:all])
      redirect_to :back
    else
      render json: @material_type.errors
    end
  end

  def destroy
    if @material_type.destroy
      redirect_to action: :index
    else
      render json: @material_type.errors
    end
  end

  private
  def set_material_type
    @material_type = MaterialType.find(params[:id])
  end

  def set_material_types
    @material_types = MaterialType.all.order(:id)
  end

  def material_type_params
    params.require(:material_type).permit(:id, material_type_translates_attributes: [:id, :name, :locale_id])
  end
end