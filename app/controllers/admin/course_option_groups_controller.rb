class Admin::CourseOptionGroupsController < AdminController
  def index
    @course_option_groups = CourseOptionGroup.includes(:course_options).where(
        locale_id: params[:locale_id] || Locale.first.id,
        course_id: params[:course_id]
    ).order('course_option_groups.id, course_options.id')

    render layout: false
  end

  def show
  end

  def new
    @course_option_group = CourseOptionGroup.new(course_id: params[:course_id], locale_id: params[:locale_id])
    @time_in_milliseconds = Time.now.to_i

    render layout: false
  end

  def create
    course_option_group = CourseOptionGroup.new(course_option_group_params)
    if course_option_group.save
      render :show, layout: false, locals: {course_option_group: course_option_group}
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def update
    course_option_group = CourseOptionGroup.find(params[:id])

    if course_option_group.update_columns(course_option_group_params)
      render :show, layout: false, locals: {course_option_group: course_option_group}
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def destroy
    status
    if CourseOptionGroup.destroy(params[:id])
      status = :ok
    else
      status = :unprocessable_entity
    end

    render nothing: true, status: status
  end

  private
  def course_option_group_params
    params.require(:course_option_group).permit(:name, :course_id, :locale_id)
  end
end
