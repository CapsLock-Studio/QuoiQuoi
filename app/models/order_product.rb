class OrderProduct < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  has_many :order_product_custom_items , dependent: :destroy
  accepts_nested_attributes_for :order_product_custom_items, allow_destroy: true
end
