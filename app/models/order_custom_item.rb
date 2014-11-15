class OrderCustomItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :user

  has_many :order_custom_item_images, dependent: :destroy
  has_many :order_custom_item_materials, dependent: :destroy
  has_many :order_custom_item_product_custom_items, dependent: :destroy
  has_many :order_custom_item_translates, dependent: :destroy

  accepts_nested_attributes_for :order_custom_item_images, allow_destroy: true
  accepts_nested_attributes_for :order_custom_item_materials
  accepts_nested_attributes_for :order_custom_item_product_custom_items
  accepts_nested_attributes_for :order_custom_item_translates

  has_attached_file :image, styles: {thumb: '100x75#', small: '300x225#', medium: '500x375#', large: '1000x750#'}, default_url: '/system/placeholder/none-:style.jpg'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
