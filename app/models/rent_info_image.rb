class RentInfoImage < ActiveRecord::Base
  has_attached_file :image, styles: {thumb: '100', medium: '500', large: '1000'}, default_url: '/system/placeholder/no-image.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
