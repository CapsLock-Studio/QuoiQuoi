class OrderProductOption < ActiveRecord::Base
  belongs_to :order_product
  belongs_to :product_option
end
