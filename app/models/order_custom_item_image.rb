class OrderCustomItemImage < ActiveRecord::Base
  belongs_to :order_custom_item

  has_attached_file :image, styles: {thumb: '100', medium: '500', large: '1000'}, default_url: '/assets/wireframe.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
