class Admin::TravelInformationController < AdminController
  authorize_resource
  before_action :set_travel_information, except: [:index, :new, :create]
  before_action :delete_blank_travel_information, except: [:update]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '文章管理', :admin_travel_information_index_path

  # GET /admin/travel_informationss
  # GET /admin/travel_informationss.json
  def index
    @area_filter = (params[:area_filter] || Area.all.each.collect{|each_area| each_area.id}).collect{|filter| filter.to_i}
    @travel_information = TravelInformation.where(area_id: @area_filter).all
  end

  # GET /admin/travel_informationss/1
  # GET /admin/travel_informationss/1.json
  def show

  end

  # GET /admin/travel_informationss/new
  def new
    add_breadcrumb '新增文章'

    @travel_information = TravelInformation.new
    @travel_information.save
  end

  # GET /admin/travel_informationss/1/edit
  def edit
    add_breadcrumb '修改文章'
  end

  # POST /admin/travel_informationss
  # POST /admin/travel_informationss.json
  def create
    @travel_information = TravelInformation.new(travel_information_params)

    respond_to do |format|
      if @travel_information.save
        format.html { redirect_to action: :index, notice: 'Create Success.' }
        format.json { render action: :index, status: :created }
      else
        format.html { render action: :new }
        format.json { render json: @travel_information.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/travel_information/1
  # PATCH/PUT /admin/travel_information/1.json
  def update
    respond_to do |format|
      if @travel_information.update_attributes(travel_information_params)
        format.html { redirect_to action: :index, notice: 'Update Success.' }
        format.json { render action: :index, status: :accepted }
      else
        format.html { render action: :edit }
        format.json { render json: @travel_information.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/travel_information/1
  # DELETE /admin/travel_information/1.json
  def destroy
    respond_to do |format|
      if @travel_information.destroy
        format.html { redirect_to action: :index }
      end
    end
  end

  private
  def set_travel_information
    @travel_information = TravelInformation.find(params[:id])
  end

  def travel_information_params
    params.require(:travel_information).permit(:id, :area_id, :title, :content)
  end

  def delete_blank_travel_information
    TravelInformation.where(area_id: [nil, '']).destroy_all
  end
end
