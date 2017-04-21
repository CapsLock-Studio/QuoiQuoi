class Slide < ApplicationRecord
  belongs_to :slide_position

  has_many :slide_translates, dependent: :destroy
  has_many :locales, through: :slide_translates

  accepts_nested_attributes_for :slide_translates

  has_attached_file :image, styles: {thumb: '120x62.5#', medium: '480x250#', large: '960x500#'}, default_url: '/system/placeholder/slide-:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end