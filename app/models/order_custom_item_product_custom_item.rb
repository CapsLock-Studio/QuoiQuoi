class OrderCustomItemProductCustomItem < ActiveRecord::Base
  belongs_to :order_custom_item
  belongs_to :product_custom_item
end
