class Admin::CourseOptionsController < AdminController
  def new
    render json: {
        :course_option_group_id => params[:course_option_group_id]
    }
  end

  def show
    render layout: false, locals: {course_option: CourseOption.find(params[:id])}
  end

  def edit
    @course_option = CourseOption.find(params[:id])

    render layout: false
  end

  def create
    course_option = CourseOption.new(course_option_params)
    if course_option.save
      render :show, layout: false, locals: {course_option: course_option}
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def update
    course_option = CourseOption.find(params[:id])
    if course_option.update(course_option_params)
      render :show, layout: false, locals: {course_option: course_option}
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def destroy
    if CourseOption.destroy(params[:id])
      render nothing: true
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  private
  def course_option_params
    params.require(:course_option).permit(:id, :course_option_group_id, :content, :price)
  end
end
