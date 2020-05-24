class ProductTagTranslate < ApplicationRecord
  belongs_to :product_tag
  belongs_to :locale
end
