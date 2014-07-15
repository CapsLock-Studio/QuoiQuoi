class Admin::RentInfoImagesController < AdminController
  authorize_resource

  before_action :set_rent_info_image, except: [:index, :create, :new]

  def index
    @rent_info_images = RentInfoImage.all.page(params[:page]).per(18)
  end

  def show

  end

  def new
    @rent_info_image = RentInfoImage.new
  end

  def edit

  end

  def create
    @rent_info_image = RentInfoImage.new(rent_info_image_params)
    respond_to do |format|
      if @rent_info_image.save
        format.html {redirect_to action: :index}
      else
        format.html {render json: @rent_info_image}
      end
    end
  end

  def update
    respond_to do |format|
      if @rent_info_image.update_attributes(rent_info_image_params)
        format.html {redirect_to action: :index}
      else
        format.html {render json: @rent_info_image.errors}
      end
    end
  end

  def destroy
    if @rent_info_image.destroy
      redirect_to action: :index
    else
      render json: @rent_info_image.errors
    end
  end

  private
    def set_rent_info_image
      @rent_info_image = RentInfoImage.find(params[:id])
    end

    def rent_info_image_params
      params.require(:rent_info_image).permit(:id, :image)
    end
end
