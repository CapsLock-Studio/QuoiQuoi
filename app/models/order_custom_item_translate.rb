class OrderCustomItemTranslate < ActiveRecord::Base
  belongs_to :order_custom_item
  belongs_to :locale
end
