class OrderProductCustomItem < ActiveRecord::Base
  belongs_to :order_product
  belongs_to :product_custom_item
end
