class OrderCustomItemTranslate < ApplicationRecord
  belongs_to :order_custom_item
  belongs_to :locale
end
