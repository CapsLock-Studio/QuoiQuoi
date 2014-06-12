class OrderCustomItemImage < ActiveRecord::Base
  belongs_to :order_custom_item

  has_attached_file :image, styles: {thumb: '100x75#', medium: '500x375#', large: '1000x750#'}, default_url: '/assets/wireframe.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
