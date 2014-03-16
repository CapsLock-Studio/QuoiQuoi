class ProductCustomTypeTranslate < ActiveRecord::Base
  belongs_to :product_custom_type
  belongs_to :locale
end
