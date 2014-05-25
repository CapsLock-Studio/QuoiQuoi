class Admin::TravelPhotosController < AdminController
  authorize_resource

  before_action :set_travel_photo, only: [:destroy]

  def index
    @travel_photos = TravelPhoto.where(travel_information_id: params[:travel_information_id])

    render json:
               @travel_photos.collect { |travel_photo|
                 {
                     name: travel_photo.photo.name,
                     size: travel_photo.photo.size,
                     url: "#{request.protocol}#{request.host_with_port}#{travel_photo.photo.url}",
                     thumbnail_url: travel_photo.photo.url(:thumb),
                     delete_url: admin_travel_photo_path(travel_photo),
                     delete_type: 'DELETE'
                 }
               }
  end

  def create
    @travel_photo = TravelPhoto.new(travel_photo_params.merge({travel_information_id: params[:travel_information_id]}))
    respond_to do |format|
      if @travel_photo.save
        format.html {}
        format.json { render json: {files: [{
                                                name: @travel_photo.photo.name,
                                                size: @travel_photo.photo.size,
                                                url: "#{request.protocol}#{request.host_with_port}#{@travel_photo.photo.url}",
                                                thumbnail_url: @travel_photo.photo.url(:thumb),
                                                delete_url: admin_travel_photo_path(@travel_photo),
                                                delete_type: 'DELETE'
                                            }]}, status: :created, location: admin_travel_photo_path(@travel_photo) }
      else
        format.html {}
        format.json { render json: @travel_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @travel_photo.destroy
    respond_to do |format|
      format.html { redirect_to uploads_url }
      format.json { head :no_content }
    end
  end

  private
  def travel_photo_params
    params.require(:travel_photo).permit(:id, :photo, :_destroy)
  end

  def set_travel_photo
    @travel_photo = TravelPhoto.find(params[:id])
  end
end
