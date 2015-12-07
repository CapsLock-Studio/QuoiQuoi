class MaterialsController < ApplicationController
  before_action :setup_navigation_content

  def index
    materials = []
    MaterialType.includes(:material_type_translate, :materials).where(material_type_translates: {locale_id: session[:locale_id]},
                                                                      visible: true, all: true).all.each do |type|
      materials << {
          type: type.material_type_translate.name,
          materials: type.materials.map do|material|
            {
                id: material.id,
                image: material.image.url(:medium),
                original_image: material.image.url(:original),
                thumb_image: material.image.url(:thumb),
                truncated_name: ApplicationController.helpers.truncate(material.material_translates.find_by_locale_id(session[:locale_id]).name, length: (session[:locale] == 'en')? 10 : 5),
                name: material.material_translates.find_by_locale_id(session[:locale_id]).name,
                selected: (JSON.parse(cookies['material-likes'] || '[]').include?(material.id))? 'selected' : ''
            }
          end
      }
    end

    render json: materials
  end

  def like
    add_breadcrumb t('home'), home_path
    add_breadcrumb '精選訂製布料'
    add_breadcrumb '布料收藏管理'
    @materials = Material.includes(:material_translate).where(material_translates: {locale_id: session[:locale_id]},
                                                              id: JSON.parse(cookies['material-likes'] || '[]'))

    @website_title = "布料收藏管理 | #{@website_title}"
  end

  private
  def setup_navigation_content
    @material_types = MaterialType.includes(:material_type_translate).where(material_type_translates: {locale_id: session[:locale_id]}, visible: true)
  end
end
