class ProductAdditionImage < ApplicationRecord
  belongs_to :product

  has_attached_file :image, styles: {thumb: '100', fit_width: '500'}, default_url: '/system/placeholder/general.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
