class Gift < ActiveRecord::Base
  has_many :gift_translates, dependent: :destroy
  accepts_nested_attributes_for :gift_translates

  has_many :user_gifts

  has_attached_file :image, styles: {thumb: '100x75#', medium: '500x375#', large: '1000x750#'}, default_url: '/assets/:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
