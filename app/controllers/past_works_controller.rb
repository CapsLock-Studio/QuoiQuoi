class PastWorksController < ApplicationController
  before_action :set_past_work_types
  before_action :set_past_work_type, only: [:index, :show]
  before_action :set_past_work, only: [:show]

  def index
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('personalize'), :past_work_types_path
    add_breadcrumb @past_work_type.past_work_type_translates.find_by_locale_id(session[:locale_id]).name

    # set seo title
    @website_title = "#{@past_work_type.past_work_type_translates.find_by_locale_id(session[:locale_id]).name} | #{@website_title}"

    @past_works = PastWork.includes(:past_work_translate)
                          .where(past_work_type_id: params[:past_work_type_id],
                                 past_work_translates: {locale_id: session[:locale_id]},
                                 visible: true)
                          .where.not(past_work_translates: {name: '', description: ''})
                          .order('past_works.id DESC, past_works.completion_time DESC')
                          .page(params[:page]).per(24)

    respond_to do |format|
      format.html
      format.json do
        render json: {
            items: @past_works.collect do |past_work|
              [
                  {
                      key: 'url',
                      value: past_work_type_past_work_path(@past_work_type, past_work)
                  },
                  {
                      key: 'image',
                      value: past_work.image.url(:small)
                  },
                  {
                      key: 'name',
                      value: ApplicationController.helpers.truncate(past_work.past_work_translate.name, length: (session[:locale] == 'en')? 38 : 20)
                  },
                  {
                      key: 'completionDate',
                      value: past_work.completion_time.strftime('%Y/%m/%d')
                  }
              ]
            end,
            nextPage: (@past_works.total_pages > @past_works.current_page)? past_work_type_past_works_path(@past_work_type, page: ((params[:page] || 1).to_i + 1), format: :json) : nil
        }
      end
    end
  end

  def show
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('personalize'), :past_work_types_path
    add_breadcrumb @past_work_type.past_work_type_translates.find_by_locale_id(session[:locale_id]).name, past_work_type_past_works_path(@past_work_type)
    add_breadcrumb @past_work.past_work_translate.name

    @website_title = "#{@past_work_type.past_work_type_translates.find_by_locale_id(session[:locale_id]).name}- #{@past_work.past_work_translate.name} | #{@website_title}"
    @meta_og_title = @past_work.past_work_translate.name
    @meta_og_description = ApplicationController.helpers.truncate(Sanitize.fragment(@past_work.past_work_translate.description), length: 100)
    @meta_og_type = 'product'
    @meta_og_image = "http://quoiquoi.tw#{@past_work.image.url(:large)}"
  end

  private
  def set_past_work_types
    @past_work_types = PastWorkType.includes(:past_work_type_translate)
                                   .where(past_work_type_translates: {locale_id: session[:locale_id]}).reorder(:sort)
  end

  def set_past_work_type
    @past_work_type = PastWorkType.find(params[:past_work_type_id])
  end

  def set_past_work
    @past_work = PastWork.includes(:past_work_translate)
                         .where(past_work_translates: {locale_id: session[:locale_id]})
                         .find(params[:id])
  end
end