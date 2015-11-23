class CoursesController < ApplicationController

  before_action :set_course, only: [:show, :calendar]
  before_action :set_months

  # GET /course
  def index
    set_breadcrumbs

    flash[:message] = nil
    @website_title = "#{t('course.title')} | #{@website_title}"

    respond_to do |format|
      format.html do
        @courses = get_courses(params[:month], params[:page])
      end

      format.json do
        render(
            json:
              (if params[:page]
                courses = get_courses(params[:month], params[:page])
                {
                    items: courses.collect do |course|
                      [
                          {
                              key: 'truncated_name',
                              value: ApplicationController.helpers.truncate(course.course_translate.name, length: (session[:locale] == 'en')? 38 : 20)
                          },
                          {
                              key: 'name',
                              value: course.course_translate.name
                          },
                          {
                              key: 'time',
                              value: "#{course.time.strftime('%Y/%m/%d %H:%M')}-#{(course.time + course.length.hours).strftime('%H:%M')} (#{t('date.day_names')[course.time.strftime('%u').to_i - 1]})"
                          },
                          {
                              key: 'teacher',
                              value: course.course_translate.teacher
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
                Course.includes(:course_translate)
                      .where(course_translates: {locale_id: session[:locale_id]}, visible: true)
                      .where.not(course_translates: {name: '', description: '', price: nil}).collect do |course|
                        {
                            title: course.course_translate.name,
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
    @newest_courses = get_courses(nil, nil).where.not(id: @course.id).limit(8)

    unless @registration
      @registration = @course.registrations.build
    end

    add_breadcrumb @course.course_translate.name

    @website_title = "#{@course.course_translate.name} | #{@website_title}"
    @meta_og_title = @course.course_translate.name

    @meta_og_description = ApplicationController.helpers.truncate(Sanitize.fragment(@course.course_translate.description), length: 100)

    @meta_og_type = 'product'
    @meta_og_image = "http://quoiquoi.tw#{@course.image.url(:large)}"
  end

  def past_all
    set_breadcrumbs
    add_breadcrumb t('course.past')

    courses = Course.includes(:course_translate).where(course_translates: {locale_id: session[:locale_id]})

    respond_to do |format|
      format.json do
        if params[:id] =~ /\d{4}-\d{1,2}/
          courses = courses.where('courses.time' => Time.parse("#{params[:id]}-1")..Time.parse("#{params[:id]}-1").end_of_month)
                           .order('courses.time DESC')
                           .page(params[:page])
                           .per(8)
          render json: {
                     items: courses.collect do |course|
                       [
                           {
                               key: 'truncated_name',
                               value: ApplicationController.helpers.truncate(course.course_translate.name, length: (session[:locale] == 'en')? 26 : 13)
                           },
                           {
                               key: 'name',
                               value: course.course_translate.name
                           },
                           {
                               key: 'teacher',
                               value: course.course_translate.teacher
                           },
                           {
                               key: 'url',
                               value: course_path(course, month: course.time.strftime('%m'))
                           },
                           {
                               key: 'image',
                               value: course.image.url(:small)
                           }
                       ]
                     end,
                     nextPage: (courses.total_pages > courses.current_page)? "/courses/past/#{params[:id]}.json?page=#{((params[:page] || 1).to_i + 1)}" : nil
                 }
        else
          render json: ''
        end
      end
      format.html do
        @courses = courses.where('courses.time >= ? AND courses.time < ?', 12.months.ago, Time.now)
                          .order('courses.time DESC')
      end
    end

    @website_title = "#{t('course.past')} | #{@website_title}"
    @meta_og_title = t('course.past')
    @meta_og_description = t('course.past')
  end

  # access able from another controller
  def set_months
    @months = []
    month_first = (Time.now.month <= 0)? 12 : Time.now.month
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
        course_model = Course.includes(:course_translate).where(course_translates: {locale_id: session[:locale_id]})

        if CourseOptionGroup.where(locale_id: session[:locale_id], course_id: params[:id]).size > 0
          course_model = course_model.includes(course_option_groups: [:course_options])
                                     .where(course_option_groups: {locale_id: session[:locale_id]})
                                     .order('course_option_groups.id')
                                     .order('course_options.id')
        end

        @course = course_model.find(params[:id])

        #  -------- this way will delete current records --------
        # trim the course_options
        #@course.course_options = @course.course_options.where(locale_id: session[:locale_id])

      rescue ActiveRecord::RecordNotFound
        redirect_to courses_path
      end
    end

    def get_courses(month, page)
      # not show any past courses
      courses = Course.includes(:course_translate, :registrations)
                      .where(course_translates: {locale_id: session[:locale_id]}, visible: true)
                      .where('courses.time > ?', Time.now.beginning_of_month)
                      .where.not(course_translates: {name: '', description: '', price: nil})

      if !month.nil?
        courses.by_month(month.to_i).order('courses.time ASC').page(page).per(24)
      elsif month == 'past'

      else
        # show now to two months after
        # @courses = @courses.where('time <= ?', Time.now + 2.months)
        courses.where('courses.time > ?', Time.now)
               .order('courses.id DESC').page(page).per(24)
      end
    end
end
