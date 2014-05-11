class Product < ActiveRecord::Base
  belongs_to :product_type

  has_many :product_translates, dependent: :destroy
  has_many :locales, through: :product_translates
  accepts_nested_attributes_for :product_translates, allow_destroy: true

  has_many :product_images
  accepts_nested_attributes_for :product_images, allow_destroy: true

  has_many :product_youtubes
  accepts_nested_attributes_for :product_youtubes, allow_destroy: true

  # has_many :product_custom_types, through: :product_custom_items
  has_many :order_products
  has_many :orders, through: :order_products

  has_attached_file :image, styles: {thumb: '100x75#', medium: '500x375#', large: '1000x750#'}, default_url: '/system/:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
