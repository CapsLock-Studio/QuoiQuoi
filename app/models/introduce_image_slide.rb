class IntroduceImageSlide < ActiveRecord::Base
  has_attached_file :image, styles: {thumb: '480x125#', medium: '960×250#'}, default_url: '/assets/slide-:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
