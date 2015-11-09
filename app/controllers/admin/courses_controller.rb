class Admin::CoursesController < AdminController
  before_action :set_course, except: [:index, :new, :create]
  before_action :delete_empty_course, except: [:create, :update]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '課程列表', :admin_courses_path

  # GET /admin/courses
  def index
    @search_filter = params[:search_filter] || %w[not_completed]
    query_condition = []
    query_condition << 'time < ?' unless @search_filter.include?('not_completed')
    query_condition << Time.now unless @search_filter.include?('not_completed')
    query_condition << 'time > ?' unless @search_filter.include?('completed')
    query_condition << Time.now unless @search_filter.include?('completed')

    @courses = Course.includes(:course_translates).where(query_condition)
  end

  # GET /admin/courses/new
  def new
    add_breadcrumb '新增課程'

    @course = Course.create

    Locale.all.order(id: :desc).each do |locale|
      @course.course_translates.create(locale_id: locale.id)
    end

    @article = @course
    @image_addition = CourseAdditionImage.new(course_id: @course.id)
  end

  # GET /admin/courses/edit
  def edit
    add_breadcrumb '修改課程'

    @article = @course
    @image_addition = CourseAdditionImage.new(course_id: @course.id)
  end

  def status
    if @course.update_columns(status_params)
      flash[:status] = status_params
      flash[:id] = @course.id

      if @course.canceled?
        CourseMailer.cancel_notification(@course.id)
      end

      redirect_to :back
    else
      render json: @course.errors
    end
  end

  # POST /admin/courses
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html {redirect_to action: :index, notice: 'Create Success.'}
      else
        format.html {render action: :new}
      end
    end
  end

  # PUT/PATCH /admin/courses/1
  def update
    if @course.update(course_params)
      flash[:update] = 'true'
      flash[:id] = @course.id

      redirect_to action: :index
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/courses/1
  def destroy
    flash[:id] = @course.id
    if @course.destroy
      flash[:destroy] = 'true'
      redirect_to :back
    else
      render json: @course.errors
    end
  end

  private
  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:id, :image, :price, :time, :length, :popular, :attendance,
                                   course_images_attributes: [:_destroy, :id, :course_id, :image],
                                   course_options_attributes: [:_destroy, :id, :content, :price, :locale_id],
                                   course_translates_attributes: [:_destroy, :id, :price, :course_id, :locale_id, :name, :teacher, :location, :description, :note])
  end

  def status_params
    if params[:canceled]
      params[:canceled_time] = Time.now
    end
    params.permit(:full, :visible, :canceled, :canceled_time)
  end

  def delete_empty_course
    # delete empty course record
    Course.all.destroy_all(time: nil)
  end
end
