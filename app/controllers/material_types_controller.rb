class MaterialTypesController < ApplicationController
  before_action :setup_navigation_content

  def show
    add_breadcrumb t('home'), home_path
    add_breadcrumb '精選訂製布料'

    params[:id] ||= MaterialType.limit(1).pluck(:id)
    @materials = Material.includes(:material_translate).where(material_translates: {
                                                                  locale_id: session[:locale_id]
                                                              }, material_type_id: params[:id])

    @website_title = "#{@material_types.find(params[:id]).material_type_translate.name} | #{@website_title}"
    @meta_og_title = @material_types.find(params[:id]).material_type_translate.name
    @meta_og_description = @material_types.find(params[:id]).material_type_translate.name
  end

  private
  def setup_navigation_content
    @material_types = MaterialType.includes(:material_type_translate).where(material_type_translates: {locale_id: session[:locale_id]}, visible: true)
  end
end
