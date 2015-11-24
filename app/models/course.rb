class Course < ActiveRecord::Base
  has_many :course_images, dependent: :destroy
  accepts_nested_attributes_for :course_images, allow_destroy: true

  has_one :course_translate
  has_many :course_translates, dependent: :destroy
  has_many :locales, through: :course_translates
  accepts_nested_attributes_for :course_translates

  has_many :registrations, dependent: :destroy

  has_many :course_option_groups
  has_many :course_options, through: :course_option_groups

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
      I18n.translate('course.canceled')
    elsif self.time < Time.now + 5.hours
      I18n.translate('course.past')
    elsif register_full? || self.full?
      I18n.translate('registration.full')
    else
      ''
    end
  end

  # Include people who have not completed payment.
  def applicants
    registrations.reject do |registration|
      registration.registration_payment.nil? || registration.registration_payment.cancel?
    end.map{|registration| registration.attendance}.inject{|sum, applicant| sum + applicant} || 0
  end

  # Registered people who already completed payment.
  def applicants_completed
    registrations.reject do |registration|
      registration.registration_payment.refunded? || !registration.registration_payment.completed?
    end.map{|registration| registration.attendance}.inject{|sum, applicant| sum + applicant} || 0
  end

  def register_full?
    (applicants >= popular)
  end

  def email_registered?(email)
    (registrations.where(email: email).size > 0)
  end

  def applicants_not_refund
    registrations.reject do |registration|
      registration.canceled? || !registration.registration_payment.completed? || registration.registration_payment.refunded?
    end.size
  end

  def refund_completed?
    (applicants_not_refund == 0)
  end

  def self.by_month(month)
    self.where('extract(month from time) = ?', month)
  end

  def month
    time.beginning_of_month
  end
end