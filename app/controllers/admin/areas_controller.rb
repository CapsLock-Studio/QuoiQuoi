class Admin::AreasController < AdminController
  authorize_resource

  before_action :set_area, except: [:index, :new, :create]

  def index
    @areas = Area.all
  end

  def new
    @area = Area.new
  end

  def edit

  end

  def create
    @area = Area.new(area_params)
    respond_to do |format|
      if @area.save
        format.html {redirect_to action: :index}
      else
        format.html {render action: :new}
      end
    end
  end

  def update
    respond_to do |format|
      if @area.update_attributes(area_params)
        format.html {redirect_to action: :index}
      else
        format.html {render action: :edit}
      end
    end
  end

  def destroy
    respond_to do |format|
      if @area.destroy
        format.html {redirect_to action: :index}
      else
        format.html {render json: @area.errors}
      end
    end
  end

  private
  def set_area
    @area = Area.find(params[:id])
  end

  def area_params
    params.require(:area).permit(:id, :name, :locale_id)
  end
end
