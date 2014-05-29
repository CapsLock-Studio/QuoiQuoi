class Admin::MaterialsController < AdminController
  authorize_resource
  before_action :set_material, except: [:index, :new, :create]

  # GET /admin/materials
  def index
    @materials = Material.all.order(id: :desc).page(params[:page]).per(16)
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
        format.html {redirect_to action: :index}
      else
        format.html {render json: material.errors}
      end
    end
  end

  # PUT/PATCH /admin/materials/1
  def update
    respond_to do |format|
      if @material.update_attributes(material_params)
        format.html {redirect_to action: :index}
      else
        format.html {render json: @material.errors}
      end
    end
  end

  # DELETE /admin/materials/1
  def destroy
    respond_to do |format|
      if @material.destroy
        format.html {redirect_to action: :index}
      end
    end
  end

  private
    def material_params
      params.require(:material).permit(:id, :image, material_translates_attributes: [:id, :locale_id, :name])
    end

    def set_material
      @material = Material.find(params[:id])
    end
end
