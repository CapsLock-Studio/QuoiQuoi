class Admin::CourseAdditionImagesController < AdminController
  authorize_resource :admin

  before_action :set_course_addition_image, only: [:destroy]

  def index
    @course_addition_images = CourseAdditionImage.where(course_id: params[:course_id])

    render json:
               (@course_addition_images.collect do |course_addition_image|
                 {
                     name: course_addition_image.image.name,
                     size: course_addition_image.image.size,
                     url: "#{request.protocol}#{request.host_with_port}#{course_addition_image.image.url}",
                     thumbnail_url: course_addition_image.image.url(:thumb),
                     delete_url: admin_course_addition_image_path(course_addition_image),
                     delete_type: 'DELETE'
                 }
               end)
  end

  def create
    @course_addition_image = CourseAdditionImage.new(course_addition_image_params)
    respond_to do |format|
      if @course_addition_image.save
        format.html {}
        format.json { render json: {files: [{
                                                name: @course_addition_image.image.name,
                                                size: @course_addition_image.image.size,
                                                url: "#{request.protocol}#{request.host_with_port}#{@course_addition_image.image.url}",
                                                thumbnail_url: @course_addition_image.image.url(:thumb),
                                                delete_url: admin_course_addition_image_path(@course_addition_image),
                                                delete_type: 'DELETE'
                                            }]}, status: :created, location: admin_course_addition_image_path(@course_addition_image) }
      else
        format.html {}
        format.json { render json: @course_addition_image.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @course_addition_image.destroy
    respond_to do |format|
      format.html {redirect_to :back}
      format.json {head :no_content}
    end
  end

  private
  def set_course_addition_image
    @course_addition_image = CourseAdditionImage.find(params[:id])
  end

  def course_addition_image_params
    params.require(:course_addition_image).permit(:id, :_destroy, :image).merge({course_id: params[:course_id]})
  end
end
