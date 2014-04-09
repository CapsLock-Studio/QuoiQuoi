class OrderCustomItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :material
end
