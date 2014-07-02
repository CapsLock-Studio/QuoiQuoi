class AreasController < ApplicationController
  before_action :set_areas
  before_action :set_area, only: [:show]

  def index
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('tourist_attractions'), :areas_path
    add_breadcrumb t('all_area')

    @articles = TravelInformation.all.order(created_at: :desc)
  end

  def show
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('tourist_attractions'), :areas_path
    add_breadcrumb @area.name

    @articles = TravelInformation.where(area_id: params[:id]).order(created_at: :desc)
  end

  private
  def set_areas
    @areas = Area.where(locale_id: session[:locale_id]).order(:id)
  end

  def set_area
    @area = Area.find(params[:id])
  end
end
