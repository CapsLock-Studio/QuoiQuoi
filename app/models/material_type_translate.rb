class MaterialTypeTranslate < ActiveRecord::Base
  belongs_to :material_type
  belongs_to :locale
end
