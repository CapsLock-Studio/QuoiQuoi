class TravelInformationController < ApplicationController
  def show
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('tourist_attractions'), :areas_path

    @areas = Area.where(locale_id: session[:locale_id]).order(:id)
    @travel_information = TravelInformation.find(params[:id])

    add_breadcrumb @travel_information.area.name
  end
end
