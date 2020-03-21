class Product < ApplicationRecord
  belongs_to :product_type

  has_and_belongs_to_many :product_tags

  has_one :product_translate
  has_many :product_translates, dependent: :destroy
  has_many :locales, through: :product_translates
  accepts_nested_attributes_for :product_translates, allow_destroy: true

  has_many :product_images
  accepts_nested_attributes_for :product_images, allow_destroy: true

  has_many :product_youtubes
  accepts_nested_attributes_for :product_youtubes, allow_destroy: true

  has_many :product_custom_items

  # has_many :product_custom_types, through: :product_custom_items
  has_many :order_products
  has_many :orders, through: :order_products

  has_many :product_option_groups
  has_many :product_options, through: :product_option_groups

  has_many :product_material_types
  accepts_nested_attributes_for :product_material_types, allow_destroy: true

  has_many :product_addition_images
  accepts_nested_attributes_for :product_addition_images, allow_destroy: true

  has_attached_file :image, styles: {thumb: '100x75#', small: '300x225#', medium: '500x375#', large: '1000x750#'}, default_url: '/system/placeholder/:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def others(locale_id, limit)
    Product.includes(:product_translate)
           .where(product_type_id: self.product_type_id,
                  product_translates: {locale_id: locale_id},
                  visible: true)
           .where.not(product_translates: {name: '', description: '', price: nil}, id: self.id)
           .order(id: :desc).limit(limit)
  end
end
