class ProductTypeTranslate < ApplicationRecord
  belongs_to :product_type
  belongs_to :locale
end
