class ProductCustomItemTranslate < ActiveRecord::Base
  belongs_to :product_custom_item
  belongs_to :locale
end
