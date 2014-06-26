class SlidePosition < ActiveRecord::Base
  has_many :slides

  has_attached_file :image, styles: {thumb: '120x62.5#', medium: '480x250#', large: '960x500#'}, default_url: '/system/placeholder/slide-:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
