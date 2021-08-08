class Image < ApplicationRecord
  has_attached_file :image, styles: {thumb: 'x80'}
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
