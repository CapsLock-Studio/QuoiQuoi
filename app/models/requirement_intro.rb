class RequirementIntro < ActiveRecord::Base
  has_many :requirement_intro_translates, dependent: :destroy
  accepts_nested_attributes_for :requirement_intro_translates, allow_destroy: true

  has_attached_file :image, styles: {thumb: '100x75#', medium: '500x375#', large: '1000x750#'}, default_url: '/system/:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
