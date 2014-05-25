class Admin::CoursesController < AdminController
  before_action :set_course, except: [:index, :new, :create]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '課程列表', :admin_courses_path

  # GET /admin/courses
  def index
    @search_filter = params[:search_filter] || %w[not_completed completed]
    query_condition = []
    query_condition << 'time < ?' unless @search_filter.include?('not_completed')
    query_condition << Time.now unless @search_filter.include?('not_completed')
    query_condition << 'time > ?' unless @search_filter.include?('completed')
    query_condition << Time.now unless @search_filter.include?('completed')

    @courses = Course.where(query_condition).order(time: :desc)
  end

  # GET /admin/courses/new
  def new
    add_breadcrumb '新增課程'

    @course = Course.new

    Locale.all.each do |locale|
      @course.course_translates.build(locale_id: locale.id)
    end
  end

  # GET /admin/courses/edit
  def edit
    add_breadcrumb '修改課程'
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
    respond_to do |format|
      if @course.update(course_params)
        format.html {redirect_to action: :index, notice: 'Update Success.'}
      else
        format.html {render action: :edit, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /admin/courses/1
  def destroy
    respond_to do |format|
      if @course.destroy
        format.html {redirect_to action: :index, notice: 'Delete Success.'}
      end
    end
  end

  private
    def set_course
      @course = Course.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:id, :image, :price, :time, :length, :popular, :attendance,
                                     course_images_attributes: [:_destroy, :id, :course_id, :image],
                                     course_translates_attributes: [:_destroy, :id, :course_id, :locale_id, :name, :teacher, :location, :description, :note])
    end
end
