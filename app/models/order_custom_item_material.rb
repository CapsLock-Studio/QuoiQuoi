class OrderCustomItemMaterial < ApplicationRecord
  belongs_to :order_custom_item
  belongs_to :material
end
