class ProductTypeTranslate < ActiveRecord::Base
  belongs_to :product_type
  belongs_to :locale
end
