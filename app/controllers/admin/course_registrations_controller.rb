class Admin::CourseRegistrationsController < AdminController
  authorize_resource :registration

  add_breadcrumb '首頁', :admin_root_path

  def index
    @search_filter = params[:search_filter] || %w[not_completed completed]
    query_condition = []
    query_condition << 'time < ?' unless @search_filter.include?('not_completed')
    query_condition << Time.now unless @search_filter.include?('not_completed')
    query_condition << 'time > ?' unless @search_filter.include?('completed')
    query_condition << Time.now unless @search_filter.include?('completed')

    @courses = Course.where('canceled = ?', false).where(query_condition).order(time: :desc)
  end

  def show
    add_breadcrumb '課程列表', :admin_course_registrations_path
    add_breadcrumb '課程報名人'
    @course = Course.find(params[:id])
  end

  # cancel course
  def update
    @course = Course.find(params[:id])

    if @course.update_attributes(canceled: true, canceled_time: Time.now)
      redirect_to action: :index
    else
      render json: @course.errors
    end
  end

  # full course
  def full_register
    @course = Course.find(params[:id])
    if @course.update_attributes(full: true, full_time: Time.now)
      redirect_to action: :index
    else
      render json: @course.errors
    end
  end

  def edit
    @locale = Locale.where(lang: 'zh-TW').first
    @course = Course.find(params[:id])
  end

  def cancel_form
    @locale = Locale.where(lang: 'zh-TW').first
    @registration = Registration.find(params[:id])
  end

  def cancel_one
    @registration = Registration.find(params[:id])

    respond_to do |format|
      if @registration.update_attributes(canceled: true, canceled_time: Time.now)
        # RegistrationMailer.cancel_remind(@registration.id).deliver
        format.html {redirect_to admin_course_registration_path(@registration.course)}
      else
        render json: @registration.errors
      end
    end
  end

  def return
    @registration = Registration.find(params[:id])

    respond_to do |format|
      if @registration.update_attributes({returned: true, returned_time: Time.now})
        format.html {redirect_to admin_course_registration_path(@registration.course)}
      end
    end
  end

  def canceled
    @total_registration = 0
    Registration.all.each do |registration|
      unless registration.canceled?
        @total_registration += registration.attendance
      end
    end
    @courses = Course.where('canceled = ? AND closed = ? AND time > ?', true, false, Time.now).order(time: :desc)
  end

  def canceled_show
    add_breadcrumb '已取消課程列表', :canceled_admin_course_registrations_path
    add_breadcrumb '課程報名人'
    @course = Course.find(params[:id])
  end

  def canceled_return
    @registration = Registration.find(params[:id])

    respond_to do |format|
      if @registration.update_attributes({returned: true, returned_time: Time.now})
        payments = Payment.all.where(completed: true, registration_id: @registration.id)
        returns = Registration.all.where(returned: true, course_id: @registration.course_id)
        if payments.length - returns.length <= 0
          @registration.course.update_attributes({closed: true, closed_time: Time.now})
        end
        format.html {redirect_to canceled_admin_course_registration_path(@registration.course)}
      end
    end
  end

  def closed
    @courses = Course.where(canceled: true).order(time: :desc)
  end

  def closed_show
    add_breadcrumb '已關閉課程列表', :closed_admin_course_registrations_path
    add_breadcrumb '課程報名人'

    @search_filter = (params[:search_filter] || %w[completed not_completed])
    course = Course.find(params[:id])

    @registrations = []

    course.registrations.each do |registration|
      if registration.payment && registration.payment.completed?
        unless @search_filter.include?('completed')
          registration = nil
        end
      else
        unless @search_filter.include?('not_completed')
          registration = nil
        end
      end
      @registrations << registration
    end
  end

  private
    def cancel_params
      params.require(:registration).permit(:reason)
    end
end