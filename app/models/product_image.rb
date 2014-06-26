class ProductImage < ActiveRecord::Base
  belongs_to :product

  has_attached_file :image, styles: {thumb: '100x75#', small: '300x225#', medium: '500x375#', large: '1000x750#'}, default_url: '/system/placeholder/:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
