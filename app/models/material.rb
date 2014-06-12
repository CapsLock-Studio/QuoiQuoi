class Material < ActiveRecord::Base
  has_many :material_translates, dependent: :destroy
  has_many :order_custom_item_materials, dependent: :destroy

  accepts_nested_attributes_for :material_translates, allow_destroy: true
  has_attached_file :image, styles: {thumb: '100x75#', medium: '500x375#', large: '1000x750#'}, default_url: '/assets/:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
