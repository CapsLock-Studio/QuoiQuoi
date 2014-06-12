class Slide < ActiveRecord::Base
  belongs_to :slide_position

  has_many :slide_translates, dependent: :destroy
  has_many :locales, through: :slide_translates

  accepts_nested_attributes_for :slide_translates

  has_attached_file :image, styles: {thumb: '192x50', medium: '960x250', large: '1920×500'}, default_url: '/assets/slide-:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end