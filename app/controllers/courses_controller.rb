class CoursesController < ApplicationController
  before_action :set_course, except: [:index]
  before_action :set_months

  # GET /course
  def index
    set_breadcrumbs

    flash[:message] = nil

    respond_to do |format|
      @courses = Course.all
      format.html do
        # not show any past courses
        if params[:month] && params[:month] != 'new'
          @courses = @courses.by_month(params[:month]).page(params[:page]).per(12).order(:time)
        else

          # show now to two months after
          # @courses = @courses.where('time <= ?', Time.now + 2.months)
          @courses = @courses.order(created_at: :desc).page(params[:page]).per(12).order(:time)
        end
      end

      format.json do
      end

      format.xml do
        @courses = @courses.limit(50)

        render template: 'courses/index.atom.builder', layout: false
      end
    end

  end

  def calendar

  end

  # GET /course/1
  def show
    set_breadcrumbs

    add_breadcrumb t('detail')

    @registration = Registration.all.where(email: (current_user)? current_user.email : nil, course_id: @course.id).order(:id).first
    @recent_courses = Course.all.where('time > ?', Time.now).where.not(id: @course.id).order(:time).limit(8)

    unless @registration
      @registration = @course.registrations.build
    end

    translate = @course.course_translates.where(locale_id: session[:locale_id]).first
    @meta_og_title = translate.name
    @meta_og_description = translate.description.gsub(/\n/, '')
    @meta_og_type = 'website'
    @meta_og_image = "http://quoiquoi#{@course.image.url(:large)}"
  end

  private
    def set_breadcrumbs
      add_breadcrumb I18n.t('home'), :root_path
      add_breadcrumb I18n.t('course.title'), :courses_path
    end

    def set_course
      begin
        @course = Course.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to action: :index
      end
    end

    def set_months
      @months = []
      month_first = Time.now.month - 1
      6.times do |index|
        @months << ((index + month_first > 12)? month_first + index - 12 : index + month_first)
      end
    end
end
