class CoursesController < ApplicationController
  before_action :set_course, except: [:index]

  # GET /course
  def index
    set_breadcrumbs

    respond_to do |format|
      format.html do
        if params[:month].blank?
          redirect_to courses_path(month: Date.today.month)
        end
        # show previous one month courses
        @courses = Course.where('time > ?', 1.month.ago).by_month(params[:month]).page(params[:page]).per(12)
      end

      format.json do
        @courses = Course.all
      end
    end

  end

  def calendar

  end

  # GET /course/1
  def show
    set_breadcrumbs

    add_breadcrumb '當月課程'

    @registration = Registration.all.where(user_id: current_or_guest_user.id, course_id: @course.id).first
    @recent_courses = Course.all.where('time > ?', Time.now).where.not(id: @course.id).order(:time).limit(8)

    unless @registration
      @registration = @course.registrations.build
    end
  end

  private
    def set_breadcrumbs
      add_breadcrumb I18n.t('header.navigation.home'), :root_path
      add_breadcrumb I18n.t('header.navigation.class'), :courses_path
    end

    def set_course
      @course = Course.find(params[:id])
    end
end
