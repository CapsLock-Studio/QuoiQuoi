class OrderProduct < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :product_option
end
