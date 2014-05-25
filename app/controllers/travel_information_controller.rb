class TravelInformationController < ApplicationController
  def show
    add_breadcrumb t('article')
    @travel_information = TravelInformation.find(params[:id])
    @articles = TravelInformation.order(created_at: :desc).page(params[:page]).per(12)
    add_breadcrumb '旅遊景點'
    add_breadcrumb @travel_information.area.name
  end
end
