class Admin::PastWorkAdditionImagesController < AdminController
  authorize_resource :admin

  before_action :set_past_work_addition_image, only: [:destroy]

  def index
    @past_work_addition_images = PastWorkAdditionImage.where(past_work_id: params[:past_work_id])

    render json:
      (@past_work_addition_images.collect do |past_work_addition_image|
        {
            name: past_work_addition_image.image.name,
            size: past_work_addition_image.image.size,
            url: "#{request.protocol}#{request.host_with_port}#{past_work_addition_image.image.url}",
            thumbnail_url: past_work_addition_image.image.url(:thumb),
            delete_url: admin_past_work_addition_image_path(past_work_addition_image),
            delete_type: 'DELETE'
        }
      end)
  end

  def create
    @past_work_addition_image = PastWorkAdditionImage.new(past_work_addition_image_params)
    respond_to do |format|
      if @past_work_addition_image.save
        format.html {}
        format.json { render json: {files: [{
                                                name: @past_work_addition_image.image.name,
                                                size: @past_work_addition_image.image.size,
                                                url: "#{request.protocol}#{request.host_with_port}#{@past_work_addition_image.image.url}",
                                                thumbnail_url: @past_work_addition_image.image.url(:thumb),
                                                delete_url: admin_past_work_addition_image_path(@past_work_addition_image),
                                                delete_type: 'DELETE'
                                            }]}, status: :created, location: admin_past_work_addition_image_path(@past_work_addition_image) }
      else
        format.html {}
        format.json { render json: @past_work_addition_image.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @past_work_addition_image.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
  def past_work_addition_image_params
    params.require(:past_work_addition_image).permit(:id, :image, :_destroy).merge({past_work_id: params[:past_work_id]})
  end

  def set_past_work_addition_image
    @past_work_addition_image = PastWorkAdditionImage.find(params[:id])
  end
end