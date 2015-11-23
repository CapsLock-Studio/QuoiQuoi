class PastWorkTypesController < ApplicationController
  def index
    add_breadcrumb t('home'), root_path
    add_breadcrumb t('past_works')

    @past_work_types = PastWorkType.includes(:past_work_type_translate)
                                   .where(past_work_type_translates: {locale_id: session[:locale_id]}, visible: true).order(:sort)
  end
end