class Admin::RequirementsController < AdminController
  authorize_resource
  before_action :set_requirement, except: [:index, :new, :create]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '招募資訊管理', :admin_requirements_path

  # GET /admin/requirements
  # GET /admin/requirements.json
  def index
    @requirements = Requirement.all
  end

  # GET /admin/requirements/1
  # GET /admin/requirements/1.json
  def show

  end

  # GET /admin/requirements/new
  def new
    add_breadcrumb '新增招募資訊'

    @requirement = Requirement.new
    Locale.all.each do |locale|
      @requirement.requirement_translates.build(locale_id: locale.id)
    end
  end

  # GET /admin/requirements/1/edit
  def edit
    add_breadcrumb '修改招募資訊'
  end

  # POST /admin/requirements
  # POST /admin/requirements.json
  def create
    @requirement = Requirement.new(requirement_params)

    respond_to do |format|
      if @requirement.save
        format.html { redirect_to action: :index, notice: 'Create Success.' }
        format.json { render action: :index, status: :created }
      else
        format.html { render action: :new }
        format.json { render json: @requirement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/requirements/1
  # PATCH/PUT /admin/requirements/1.json
  def update
    respond_to do |format|
      if @requirement.update_attributes(requirement_params)
        format.html { redirect_to action: :index, notice: 'Update Success.' }
        format.json { render action: :index, status: :accepted }
      else
        format.html { render action: :edit }
        format.json { render json: @requirement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/requirements/1
  # DELETE /admin/requirements/1.json
  def destroy
    respond_to do |format|
      if @requirement.destroy
        format.html { redirect_to action: :index }
      end
    end
  end

  private
  def set_requirement
    @requirement = Requirement.find(params[:id])
  end

  def requirement_params
    params.require(:requirement).permit(:id, requirement_translates_attributes: [:id, :title, :description, :locale_id])
  end
end
