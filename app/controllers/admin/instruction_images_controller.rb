class Admin::InstructionImagesController < AdminController
  authorize_resource

  before_action :set_instruction_image, only: [:destroy]

  def index
    @instruction_images = InstructionImage.where(instruction_id: params[:instruction_id])

    render json:
               @instruction_images.collect { |image|
                 {
                     name: image.image.name,
                     size: image.image.size,
                     url: "#{request.protocol}#{request.host_with_port}#{image.image.url}",
                     thumbnail_url: image.image.url(:thumb),
                     delete_url: admin_instruction_image_path(image),
                     delete_type: 'DELETE'
                 }
               }
  end

  def create
    @instruction_images = InstructionImage.new(instruction_image_params.merge({instruction_id: params[:instruction_id]}))
    respond_to do |format|
      if @instruction_images.save
        format.html {}
        format.json { render json: {files: [{
                                                name: @instruction_images.image.name,
                                                size: @instruction_images.image.size,
                                                url: "#{request.protocol}#{request.host_with_port}#{@instruction_images.image.url}",
                                                thumbnail_url: @instruction_images.image.url(:thumb),
                                                delete_url: admin_instruction_image_path(@instruction_images),
                                                delete_type: 'DELETE'
                                            }]}, status: :created, location: admin_instruction_image_path(@instruction_images) }
      else
        format.html {}
        format.json { render json: @instruction_images.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @instruction_image.destroy
    respond_to do |format|
      format.html { redirect_to uploads_url }
      format.json { head :no_content }
    end
  end

  private
  def instruction_image_params
    params.require(:instruction_image).permit(:id, :image, :_destroy)
  end

  def set_instruction_image
    @instruction_image = InstructionImage.find(params[:id])
  end
end
