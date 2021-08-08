class Admin::ImagesController < AdminController
  authorize_resource

  before_action :set_image, only: [:destroy]

  def index
    @images = Image.order(:id, :desc)

    render json:
      @images.collect { |image|
        {
            name: image.image.name,
            size: image.image.size,
            url: "#{request.protocol}#{request.host_with_port}#{image.image.url}",
            thumbnail_url: image.image.url(:thumb),
            delete_url: admin_image_path(image),
            delete_type: 'DELETE'
        }
      }
  end

  def create
    @image = Image.new(image_params)
    respond_to do |format|
      if @image.save
        format.html {}
        format.json { render json: {files: [{
            name: @image.image.name,
            size: @image.image.size,
            url: "#{request.protocol}#{request.host_with_port}#{@image.image.url}",
            thumbnail_url: @image.image.url(:thumb),
            delete_url: admin_image_path(@image),
            delete_type: 'DELETE'
                                            }]}, status: :created, location: admin_image_path(@image) }
      else
        format.html {}
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
    def image_params
      params.require(:image).permit(:id, :image, :_destroy)
    end

    def set_image
      @image = Image.find(params[:id])
    end
end
