class ProductCustomItem < ApplicationRecord
  belongs_to :product
  has_many :order_custom_item_product_custom_items
  has_many :product_custom_item_translates
  accepts_nested_attributes_for :product_custom_item_translates

  has_attached_file :image, styles: {thumb: '100x75#', small: '300x225#', medium: '500x375#', large: '1000x750#'}, default_url: '/system/placeholder/:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
