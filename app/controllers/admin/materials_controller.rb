class Admin::MaterialsController < AdminController
  authorize_resource
  before_action :set_material, except: [:index, :new, :create]
  before_action :set_material_type, only: [:index, :new, :edit]

  # GET /admin/materials
  def index
    @materials = @material_type.materials.order(id: :desc).page(params[:page]).per(16)
    respond_to do |format|
      format.html {}
      format.json {render json: @materials}
    end
  end

  # GET /admin/materials/new
  def new
    @material = Material.new
    Locale.all.each do |locale|
      @material.material_translates.build(locale_id: locale.id)
    end
  end

  # GET /admin/materials/1/edit
  def edit

  end

  # POST /admin/materials
  def create
    respond_to do |format|
      material = Material.new(material_params)
      if material.save
        format.html {redirect_to admin_material_type_materials_path(material.material_type)}
      else
        format.html {render json: material.errors}
      end
    end
  end

  # PUT/PATCH /admin/materials/1
  def update
    respond_to do |format|
      if @material.update_attributes(material_params)
        format.html {redirect_to admin_material_type_materials_path(@material.material_type)}
      else
        format.html {render json: @material.errors}
      end
    end
  end

  def visible
    if @material.update_attribute(:visible, params[:visible])
      redirect_to :back
    else
      render json: @material.errors
    end
  end

  # DELETE /admin/materials/1
  def destroy
    respond_to do |format|
      if @material.destroy
        format.html {redirect_to :back}
      end
    end
  end

  private
    def material_params
      params.require(:material).permit(:id, :image, :material_type_id, material_translates_attributes: [:id, :locale_id, :name])
    end

    def set_material
      @material = Material.find(params[:id])
    end

    def set_material_type
      @material_type = MaterialType.find(params[:material_type_id])
    end
end
