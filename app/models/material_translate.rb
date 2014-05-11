class MaterialTranslate < ActiveRecord::Base
  belongs_to :material
  belongs_to :locale
end
