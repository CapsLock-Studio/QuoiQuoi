class ProductCustomItemTranslate < ApplicationRecord
  belongs_to :locale
  belongs_to :product_custom_item
end
