class SlidePosition < ActiveRecord::Base
  has_many :slides

  has_attached_file :image, styles: {thumb: '192x50', medium: '960x250', large: '1920×500'}, default_url: '/system/slide-:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
