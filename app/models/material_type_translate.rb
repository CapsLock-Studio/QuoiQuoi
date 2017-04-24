class MaterialTypeTranslate < ApplicationRecord
  belongs_to :material_type
  belongs_to :locale
end
