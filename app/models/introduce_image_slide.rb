class IntroduceImageSlide < ActiveRecord::Base
  has_attached_file :image, styles: {medium: '480x125#', large: '960×250#'}, default_url: '/system/placeholder/intro-:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
