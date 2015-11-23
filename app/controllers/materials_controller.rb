class MaterialsController < ApplicationController
  def index
    materials = []
    MaterialType.includes(:material_type_translate, :materials).where(material_type_translates: {locale_id: session[:locale_id]},
                                                          visible: true, all: true).all.each do |type|
      materials << {
          type: type.material_type_translate.name,
          materials: type.materials.map do|material|
            {
                id: material.id,
                image: material.image.url(:thumb)
            }
          end
      }
    end

    render json: materials
  end
end
