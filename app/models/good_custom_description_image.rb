class GoodCustomDescriptionImage < ActiveRecord::Base
  belongs_to :good

  has_attached_file :image, style: {thumb: '100x75#', medium: '500x375#', large: '1000x750#'}
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
