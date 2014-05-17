class Admin::CourseRegistrationsController < AdminController
  authorize_resource :registration

  add_breadcrumb '首頁', :admin_root_path

  def index
    @total_registration = 0
    @total_attendance = 0
    Payment.all.where(completed: true).where.not(registration_id: '').each do |payment|
      unless payment.registration.returned?
        @total_attendance += payment.registration.attendance
      end
    end

    Registration.all.each do |registration|
      unless registration.canceled?
        @total_registration += registration.attendance
      end
    end

    @courses = Course.where('canceled = ? AND closed = ? AND time > ?', false, false, Time.now)
  end

  def show
    add_breadcrumb '課程列表', :admin_course_registrations_path
    add_breadcrumb '課程報名人'
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes({canceled: true, canceled_time: Time.now}) && @course.registrations.update_all({canceled: true, canceled_time: Time.now})
        format.html {redirect_to admin_course_registrations_path}
      end
    end
  end

  def cancel_one
    @registration = Registration.find(params[:id])

    respond_to do |format|
      if @registration.update_attributes({canceled: true, canceled_time: Time.now})
        format.html {redirect_to admin_course_registration_path(@registration.course)}
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
    @courses = Course.where('canceled = ? AND closed = ? AND time > ?', true, false, Time.now)
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
    @courses = Course.where('canceled = ? AND closed = ?', true, true)
  end

  def closed_show
    add_breadcrumb '已關閉課程列表', :closed_admin_course_registrations_path
    add_breadcrumb '課程報名人'
    @course = Course.find(params[:id])
  end
end
