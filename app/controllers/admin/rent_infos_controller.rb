class Admin::RentInfosController < AdminController
  authorize_resource

  before_action :set_rent_info, except: [:index, :new, :create]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '場地租借資訊列表', :admin_rent_infos_path

  def index
    @rent_infos = RentInfo.all
  end

  def show

  end

  def edit

  end

  def new
    add_breadcrumb '新增場地租借資訊'

    @rent_info = RentInfo.new
    Locale.all.each do |locale|
      @rent_info.rent_info_translates.build(locale_id: locale.id)
    end
  end

  def create
    @rent_info = RentInfo.new(rent_info_params)
    respond_to do |format|
      if @rent_info.save
        format.html {redirect_to action: :index}
      else
        format.html {render json: @rent_info.errors}
      end
    end
  end

  def update
    respond_to do |format|
      if @rent_info.update_attributes(rent_info_params)
        format.html {redirect_to action: :index}
      else
        format.html {render json: @rent_info.errors}
      end
    end
  end

  def destroy
    respond_to do |format|
      if @rent_info.destroy
        format.html {redirect_to action: :index}
      else
        format.html {render json: @rent_info.errors}
      end
    end
  end

  private
    def set_rent_info
      @rent_info = RentInfo.find(params[:id])
    end

    def rent_info_params
      params.require(:rent_info).permit(:id, rent_info_translates_attributes: [:id, :_destroy, :title, :content, :rent_info_id, :locale_id])
    end
end
