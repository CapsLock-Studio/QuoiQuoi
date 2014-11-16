class Course < ActiveRecord::Base
  has_many :course_images, dependent: :destroy
  accepts_nested_attributes_for :course_images, allow_destroy: true

  has_one :course_translate
  has_many :course_translates, dependent: :destroy
  has_many :locales, through: :course_translates
  accepts_nested_attributes_for :course_translates

  has_many :registrations, dependent: :destroy

  has_many :course_options, dependent: :destroy
  accepts_nested_attributes_for :course_options, allow_destroy: true

  has_attached_file :image, styles: {thumb: '100x75#', small: '300x225#', medium: '500x375#', large: '1000x750#'}, default_url: '/system/placeholder/:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def status
    attendance = self.registrations.reject do |registration|
      registration.canceled?
    end.collect do |registration|
      (registration.payment && registration.payment.completed?)? registration.attendance : 0
    end.inject{|sum, attendance| sum + attendance} || 0

    if self.canceled?
      I18n.translate('registration.cancel')
    elsif self.time < Time.now + 5.hours
      I18n.translate('course.past')
    elsif attendance >= self.popular || self.full?
      I18n.translate('registration.full')
    else
      ''
    end
  end

  def self.by_month(month)
    self.where('extract(month from time) = ?', month)
  end
end