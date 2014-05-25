class TravelPhoto < ActiveRecord::Base
  belongs_to :travel_information

  has_attached_file :photo, styles: {thumb: 'x80'}
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
end
