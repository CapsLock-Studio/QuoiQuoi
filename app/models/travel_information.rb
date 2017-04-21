class TravelInformation < ApplicationRecord
  belongs_to :area
  has_many :travel_photos, dependent: :destroy

  has_attached_file :image, styles: {medium: '300x225#'}, default_url: '/system/placeholder/:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
