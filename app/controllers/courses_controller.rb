class CoursesController < ApplicationController
  before_action :set_course, except: [:index]

  # GET /course
  def index
    set_breadcrumbs

    respond_to do |format|
      @courses = Course.where(canceled: false).where('time > ?', Time.now)
      format.html do
        # not show any past courses
        if params[:month] && params[:month] != 'recent'
          @courses = @courses.by_month(params[:month])
        else

          # show now to two months after
          # @courses = @courses.where('time <= ?', Time.now + 2.months)
        end

        # make page
        @courses = @courses.page(params[:page]).per(12).order(:time)
      end

      format.json do
      end

      format.rss do
        @courses = @courses.limit(50)
      end
    end

  end

  def calendar

  end

  # GET /course/1
  def show
    set_breadcrumbs

    add_breadcrumb t('detail')

    @registration = Registration.all.where(user_id: (current_user)? current_user.id : nil, course_id: @course.id).first
    @recent_courses = Course.all.where('time > ?', Time.now).where(canceled: false).where.not(id: @course.id).order(:time).limit(8)

    unless @registration
      @registration = @course.registrations.build
    end
  end

  private
    def set_breadcrumbs
      add_breadcrumb I18n.t('home'), :root_path
      add_breadcrumb I18n.t('course.title'), :courses_path
    end

    def set_course
      begin
        @course = Course.where(id: params[:id], canceled: false).first
      rescue ActiveRecord::RecordNotFound
        redirect_to action: :index
      end
    end
end
