class Course < ActiveRecord::Base
  scope :by_month, lambda {|month| where('extract(month from time) = ?', month)}

  has_many :course_images, dependent: :destroy
  accepts_nested_attributes_for :course_images, allow_destroy: true

  has_many :course_translates, dependent: :destroy
  has_many :locales, through: :course_translates
  accepts_nested_attributes_for :course_translates

  has_many :registrations

  has_attached_file :image, styles: {thumb: '100x75#', small: '300x225#', medium: '500x375#', large: '1000x750#'}, default_url: '/assets/:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
