class CoursesController < ApplicationController
  before_action :set_course, except: [:index]
  before_action :set_months

  # GET /course
  def index
    set_breadcrumbs

    flash[:message] = nil
    @website_title = "#{t('course.title')} | #{@website_title}"

    respond_to do |format|
      format.html do
        @courses = get_courses
      end

      format.json do
        render(
            json:
              (if params[:page]
                courses = get_courses
                {
                    items: courses.collect do |course|
                      course_translate = course.course_translates.find_by_locale_id(session[:locale_id])
                      [
                          {
                              key: 'name',
                              value: ApplicationController.helpers.truncate(course_translate.name, length: (session[:locale] == 'en')? 38 : 20)
                          },
                          {
                              key: 'time',
                              value: "#{course.time.strftime('%Y/%m/%d %H:%M')}-#{(course.time + course.length.hours).strftime('%H:%M')} (#{t('date.day_names')[course.time.strftime('%u').to_i - 1]})"
                          },
                          {
                              key: 'teacher',
                              value: course_translate.teacher
                          },
                          {
                              key: 'url',
                              value: course_path(course, month: course.time.strftime('%m'))
                          },
                          {
                              key: 'image',
                              value: course.image.url(:small)
                          },
                          {
                              key: 'status',
                              value: course.status
                          }
                      ]
                    end,
                    nextPage: (courses.total_pages > courses.current_page)? courses_path(month: params[:month], page: ((params[:page] || 1).to_i + 1), format: :json) : nil
                }
              else
                Course.where(visible: true).collect do |course|
                  course_translate = course.course_translates.find_by_locale_id(session[:locale_id])
                  {
                      title: course_translate.name,
                      start: course.time.strftime('%Y-%m-%d'),
                      url: course_path(course, month: course.time.strftime('%m'))
                  }
                end
              end)
        )
      end

      format.xml do
        @courses = get_courses.limit(50)

        render template: 'courses/index.atom.builder', layout: false
      end
    end

  end

  def calendar

  end

  # GET /course/1
  def show
    set_breadcrumbs

    @registration = Registration.all.where(email: (current_user)? current_user.email : nil, course_id: @course.id).order(:id).first
    @recent_courses = Course.all.where('time > ?', Time.now).where.not(id: @course.id).order(:time).limit(8)

    unless @registration
      @registration = @course.registrations.build
    end

    translate = @course.course_translates.find_by_locale_id(session[:locale_id])
    add_breadcrumb translate.name

    @website_title = "#{translate.name} | #{@website_title}"
    @meta_og_title = translate.name
    @meta_og_description = translate.description.gsub(/\n/, '')
    @meta_og_type = 'product'
    @meta_og_image = "http://quoiquoi.tw#{@course.image.url(:large)}"
  end

  # access able from another controller
  def set_months
    @months = []
    month_first = Time.now.month - 1
    6.times do |index|
      @months << ((index + month_first > 12)? month_first + index - 12 : index + month_first)
    end

    @months
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

    def get_courses
      courses = Course.where(visible: true).not_blank_translates(session[:locale_id])

      # not show any past courses
      if params[:month] && params[:month] != 'new'
        courses.by_month(params[:month]).page(params[:page]).per(24).order(:time)
      else

        # show now to two months after
        # @courses = @courses.where('time <= ?', Time.now + 2.months)
        courses.order(id: :desc).page(params[:page]).per(24)
      end
    end
end
